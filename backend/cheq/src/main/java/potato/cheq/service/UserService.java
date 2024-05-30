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
import potato.cheq.dto.*;
import potato.cheq.entity.UserEntity;
import potato.cheq.entity.UuidEntity;
import potato.cheq.repository.UserRepository;
import potato.cheq.repository.UuidRepository;
import potato.cheq.service.jwt.JwtTokenProvider;
import potato.cheq.service.jwt.RedisService;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final RedisService redisService;
    private final JwtTokenProvider jwtTokenProvider;
    private final UserRepository userRepository;
    private final UuidRepository uuidRepository;

    public Long setUserData(RequestUserDto dto) throws Exception { // 관리자 기능
        if (userRepository.existsByStudentId(dto.getStudentId())) {
            throw new Exception("이미 존재하는 사용자 정보입니다.");
        }

        UserEntity user = userRepository.save(dto.toEntity());
        return user.getId();
    }

//    public Long setUserDevice(RequestUpdateUserDto dto) throws Exception {
//        if (uuidRepository.existsByDeviceUuid(dto.getUuid())) {
//            throw new Exception("이미 존재하는 기기입니다.");
//        }
//
//        UuidEntity uuid = userRepository.save(dto.toEntity());
//        return uuid.getId();
//    }

    public ResponseEntity<String> login(RequestLoginDto dto, HttpServletResponse response) throws Exception {
        UserEntity user = userRepository.findByStudentId(dto.getStudentId());

        if (user == null) {
            throw new Exception("유저 정보를 찾을 수 없습니다.");
        }

        this.setJwtTokenInHeader(user.getId(), response);

        return ResponseEntity.ok("로그인 성공");
    }

    private void setJwtTokenInHeader(Long id, HttpServletResponse response) throws Exception {
        String accessToken = jwtTokenProvider.createAccessToken(id);
        String refreshToken = jwtTokenProvider.createRefreshToken(id);

        jwtTokenProvider.setHeaderAccessToken(response, accessToken);
        jwtTokenProvider.setHeaderRefreshToken(response, refreshToken);
        redisService.setValues(id, refreshToken);


    }

    public void reissueToken(HttpServletRequest request, HttpServletResponse response) {
        String refreshToken = jwtTokenProvider.resolveRefreshToken(request);

        jwtTokenProvider.validateRefreshToken(refreshToken);

        String newAccessToken = jwtTokenProvider.reissueAccessToken(refreshToken, response);
        String newRefreshToken = jwtTokenProvider.reissueRefreshToken(refreshToken, response);

        jwtTokenProvider.setHeaderAccessToken(response, newAccessToken);
        jwtTokenProvider.setHeaderRefreshToken(response, newRefreshToken);

    }


}
