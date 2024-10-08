package potato.cheq.service;

import io.jsonwebtoken.io.IOException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import potato.cheq.dto.request.RequestLoginDto;
import potato.cheq.dto.request.RequestUpdateUserDto;
import potato.cheq.dto.request.RequestUserDto;
import potato.cheq.dto.request.UserUpdateRequestDto;
import potato.cheq.dto.response.UserMyPageDto;
import potato.cheq.entity.UserEntity;
import potato.cheq.enums.UserRole;
import potato.cheq.error.security.ErrorCode;
import potato.cheq.error.security.requestError.DuplicateException;
import potato.cheq.error.security.requestError.NotFoundException;
import potato.cheq.error.security.requestError.UnAuthorizedException;
import potato.cheq.repository.UserRepository;
import potato.cheq.repository.UuidRepository;
import potato.cheq.service.jwt.JwtTokenProvider;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static potato.cheq.error.security.ErrorCode.NOT_FOUND_EXCEPTION;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final JwtTokenProvider jwtTokenProvider;
    private final UserRepository userRepository;
    private final UuidRepository uuidRepository;
    private final PasswordEncoder passwordEncoder;


    public Long setUserData(RequestUserDto dto) { // 관리자 기능
        if (userRepository.existsByStudentId(dto.getStudentId())) {
            throw new DuplicateException("이미 존재하는 사용자 정보입니다.", ErrorCode.FORBIDDEN_EXCEPTION);
        }

        UserEntity user = userRepository.save(dto.toEntity());
        return user.getId();
    }

    public void setUserDevice(HttpServletRequest request, Long id, RequestUpdateUserDto dto) throws Exception {
        if (uuidRepository.existsByDeviceUuid(dto.getUuid())) {
            throw new Exception("이미 존재하는 기기입니다.");
        }

        UserEntity originUser = userRepository.findById(id)
                .orElseThrow(() -> new NullPointerException());

        String updatedUuid = dto.getUuid();
        originUser.updateUuid(updatedUuid);
        userRepository.save(originUser);

    }

    public Map<String, String> login(RequestLoginDto dto, HttpServletResponse response) throws Exception {
        UserEntity user = userRepository.findByStudentId(dto.getStudentId());

        if (user == null) {
            throw new NotFoundException("유저 정보를 찾을 수 없습니다.", NOT_FOUND_EXCEPTION);
        }
//
//        if (!passwordEncoder.matches(dto.getPassword(), admin.getPassword())) {
//            throw new UnAuthorizedException("401", ErrorCode.ACCESS_DENIED_EXCEPTION);
//        }

        String at = setBodyAtToken(dto.getStudentId(), response);
        String rt = setBodyRtToken(dto.getStudentId(), response);

        Map<String, String> tokens = new HashMap<>();
        tokens.put("at",at);
        tokens.put("rt",rt);


        return tokens;
    }

    public String setBodyAtToken(String studentId, HttpServletResponse response) {
        UserEntity user = userRepository.findByStudentId(studentId);

        UserRole role = user.getUserRole();

        return jwtTokenProvider.createAccessToken(user.getId(), role);
    }

    public String setBodyRtToken(String studentId, HttpServletResponse response) {
        UserEntity user = userRepository.findByStudentId(studentId);

        UserRole role = user.getUserRole();

        return jwtTokenProvider.createRefreshToken(user.getId(), role);
    }


//    private void setJwtTokenInHeader(Long id, String role, HttpServletResponse response) throws Exception {
//        String accessToken = jwtTokenProvider.createAccessToken(id, role);
//        String refreshToken = jwtTokenProvider.createRefreshToken(id, role);
//
//        jwtTokenProvider.setHeaderAccessToken(response, accessToken);
//        jwtTokenProvider.setHeaderRefreshToken(response, refreshToken);
//
//    }

    public void reissueToken(HttpServletRequest request, HttpServletResponse response) {
        String refreshToken = jwtTokenProvider.resolveRefreshToken(request);

        jwtTokenProvider.validateRefreshToken(refreshToken);

        String newAccessToken = jwtTokenProvider.reissueAccessToken(refreshToken, response);
//        String newRefreshToken = jwtTokenProvider.reissueRefreshToken(refreshToken, response);

        jwtTokenProvider.setHeaderAccessToken(response, newAccessToken);
//        jwtTokenProvider.setHeaderRefreshToken(response, newRefreshToken);

    }

    public UserMyPageDto viewUserInfo(HttpServletRequest request) throws IOException {
        Optional<UserEntity> userEntityOpt = findByUserToken(request);

        if (userEntityOpt.isPresent()) {
            UserEntity userEntity = userEntityOpt.get();
            return UserMyPageDto.builder()
                    .email(userEntity.getEmail())
                    .studentId(userEntity.getStudentId())
                    .seat(userEntity.getSeat())
                    .major(userEntity.getMajor())
                    .build();
        } else {
            throw new UnAuthorizedException("404", NOT_FOUND_EXCEPTION);
        }
    }

    public void updateUser(UserUpdateRequestDto requestDto, HttpServletRequest request) {
        Optional<UserEntity> userOptional = findByUserToken(request);

        if (userOptional.isPresent()) {
            UserEntity user = userOptional.get();

            LocalDateTime lastUpdate = userRepository.findLastUpdatedByUserId(user.getId());
            LocalDateTime now = LocalDateTime.now();

            if (lastUpdate == null || ChronoUnit.DAYS.between(lastUpdate, now) >= 3) {
                user.update(requestDto);
                userRepository.save(user);
            }
            else{
                throw new RuntimeException("정보는 3일 뒤에 수정 할 수 있습니다");
            }
        }
    }

    public Optional<UserEntity> findByUserToken(HttpServletRequest request) {
        try {
            String token = jwtTokenProvider.resolveAccessToken(request);
            String accessTokenType = jwtTokenProvider.extractTokenType(token);


            if ("refresh".equals(accessTokenType)) {
                throw new UnAuthorizedException("RefreshToken은 사용할 수 없습니다.", ErrorCode.INVALID_TOKEN_EXCEPTION);
            }

            if (token == null) {
                return Optional.empty();
            }

            String memberId = jwtTokenProvider.extractMemberId(token);
            return Optional.ofNullable(userRepository.findByStudentId(memberId));


        } catch (Exception e) {
            throw new RuntimeException(e);

        }
    }


}