package potato.cheq.service;

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
import potato.cheq.entity.UserEntity;
import potato.cheq.repository.UserRepository;
import potato.cheq.service.jwt.JwtTokenProvider;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

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

    }

    public void reissueToken(HttpServletRequest request, HttpServletResponse response) {
        String refreshToken = jwtTokenProvider.resolveRefreshToken(request);

        jwtTokenProvider.validateRefreshToken(refreshToken);

//        String newAccessToken = jwtTokenProvider.rei
    }


}
