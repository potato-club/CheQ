package potato.cheq.service;

import io.jsonwebtoken.io.IOException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.apache.catalina.User;
import org.apache.coyote.BadRequestException;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import potato.cheq.dto.NFCRequestDto;
import potato.cheq.dto.RequestUserDevice;
import potato.cheq.dto.RequestUserDto;
import potato.cheq.dto.UserMyPageDto;
import potato.cheq.entity.UserEntity;
import potato.cheq.error.security.ErrorCode;
import potato.cheq.error.security.requestError.UnAuthorizedException;
import potato.cheq.repository.UserRepository;
import potato.cheq.service.jwt.JwtTokenProvider;
import potato.cheq.service.jwt.RedisService;

import java.util.Optional;

import static potato.cheq.error.security.ErrorCode.NOT_FOUND_EXCEPTION;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final RedisService redisService;
    private final JwtTokenProvider jwtTokenProvider;
    private final UserRepository userRepository;

    public Long setUserData(RequestUserDto dto) throws Exception {
        if (userRepository.existsByStudentId(dto.getStudentId())) {
            throw new Exception("이미 존재하는 사용자 정보입니다.");
        }

        if (userRepository.existsByUuid(dto.getUuid())) {
            throw new Exception("이미 존재하는 기기정보값입니다.");
        }

        UserEntity user = userRepository.save(dto.toEntity());
        return user.getId();
    }

    public Long setUserDevice(RequestUserDevice dto) throws Exception {
        if (userRepository.existsByUuid(dto.getUuid())) {
            throw new Exception("이미 존재하는 기기입니다.");
        }

        UserEntity user = userRepository.save(dto.toEntity());
        return user.getId();
    }

    public ResponseEntity<String> login(RequestUserDto dto, HttpServletResponse response) throws Exception {
        UserEntity user = userRepository.findByStudentId(dto.getStudentId());

        if (user == null) {
            throw new Exception("유저 정보를 찾을 수 없습니다.");
        }

        this.setJwtTokenInHeader(dto.getStudentId(), response);

        return ResponseEntity.ok("로그인 성공");
    }

    private void setJwtTokenInHeader(String studentID, HttpServletResponse response) throws Exception {
        String accessToken = jwtTokenProvider.createAccessToken(studentID);
        String refreshToken = jwtTokenProvider.createRefreshToken(studentID);

        jwtTokenProvider.setHeaderAccessToken(response, accessToken);
        jwtTokenProvider.setHeaderRefreshToken(response, refreshToken);
        redisService.setValues(studentID, refreshToken);
    }

    public void reissueToken(HttpServletRequest request, HttpServletResponse response) {
        String refreshToken = jwtTokenProvider.resolveRefreshToken(request);

        jwtTokenProvider.validateRefreshToken(refreshToken);

        String newAccessToken = jwtTokenProvider.reissueAccessToken(refreshToken, response);
        String newRefreshToken = jwtTokenProvider.reissueRefreshToken(refreshToken, response);

        jwtTokenProvider.setHeaderAccessToken(response, newAccessToken);
        jwtTokenProvider.setHeaderRefreshToken(response, newRefreshToken);

    }

    public UserMyPageDto viewUserInfo(HttpServletRequest request) throws IOException {
        Optional<UserEntity> userEntityOpt = findByUserToken(request);

        if (userEntityOpt.isPresent()) {
            UserEntity userEntity = userEntityOpt.get();
            return UserMyPageDto.builder()
                    .email(userEntity.getEmail())
                    .studentId(userEntity.getStudentId())
                    .seat(userEntity.getSeat())
                    .build();
        } else {
            throw new UnAuthorizedException("404", NOT_FOUND_EXCEPTION);
        }
    }

    public Optional<UserEntity> findByUserToken(HttpServletRequest request) throws UnAuthorizedException {
        try {
            String token = jwtTokenProvider.resolveAccessToken(request);
            String accessTokenType = jwtTokenProvider.extractTokenType(token);

            if ("refresh".equals(accessTokenType)) {
                throw new UnAuthorizedException("RefreshToken은 사용할 수 없습니다.", ErrorCode.INVALID_TOKEN_EXCEPTION);
            }

            if (token == null) {
                return Optional.empty();
            }

            Long memberId = Long.valueOf(jwtTokenProvider.extractMemberId(token));
            return userRepository.findById(memberId);

        } catch (Exception e) {
            throw new UnAuthorizedException("토큰 처리 중 예외가 발생했습니다.", ErrorCode.INVALID_TOKEN_EXCEPTION);
        }
    }



}
