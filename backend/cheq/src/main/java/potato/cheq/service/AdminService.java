package potato.cheq.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import potato.cheq.dto.admin.RequestAdminLoginDto;
import potato.cheq.dto.admin.RequestUpdateStudentDto;
import potato.cheq.entity.AdminEntity;
import potato.cheq.entity.UserEntity;
import potato.cheq.error.security.requestError.BadRequestException;
import potato.cheq.error.security.requestError.NotFoundException;
import potato.cheq.error.security.requestError.UnAuthorizedException;
import potato.cheq.repository.AdminRepository;
import potato.cheq.repository.UserRepository;
import potato.cheq.service.jwt.JwtTokenProvider;
import potato.cheq.error.security.ErrorCode;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final JwtTokenProvider jwtTokenProvider;
    private final AdminRepository adminRepository;
    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    public ResponseEntity<String> adminLogin(RequestAdminLoginDto requestDto, HttpServletResponse response) throws Exception {
        AdminEntity admin = adminRepository.findByEmail(requestDto.getEmail())
                .orElseThrow(() -> new NotFoundException("Admin not found", ErrorCode.NOT_FOUND_EXCEPTION));

        if (!passwordEncoder.matches(requestDto.getPassword(), admin.getPassword())) {
            return ResponseEntity.status(HttpServletResponse.SC_UNAUTHORIZED).body("Invalid password");
        }

        this.setJwtTokenInHeader(admin.getId(), String.valueOf(admin.getUserRole()), response);
        return ResponseEntity.ok("Admin 로그인 성공");
    }

    public void updateStudent(RequestUpdateStudentDto requestDto, HttpServletRequest request, Long userId) throws Exception {
        String token = jwtTokenProvider.resolveAccessToken(request);
        if (token == null || !jwtTokenProvider.validateAccessToken(token)) {
            throw new UnAuthorizedException("토큰 오류", ErrorCode.UNAUTHORIZED_EXCEPTION);
        }

        String userRole = jwtTokenProvider.extractRole(token);

        if (!userRole.equals("ADMIN")) {
            throw new UnAuthorizedException("Admin 권한이 없습니다", ErrorCode.UNAUTHORIZED_EXCEPTION);
        }

        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("학생을 찾을 수 없습니다", ErrorCode.NOT_FOUND_EXCEPTION));

        user.Adminupdate(requestDto);
        userRepository.save(user);
    }



    public void deleteStudent(HttpServletRequest request, String studentId) throws Exception {
        String token = jwtTokenProvider.resolveAccessToken(request);
        if (token == null || !jwtTokenProvider.validateAccessToken(token)) {
            throw new UnAuthorizedException("토큰 오류", ErrorCode.UNAUTHORIZED_EXCEPTION);
        }

        String userRole = jwtTokenProvider.extractRole(token);

        if (!userRole.equals("ADMIN")) {
            throw new UnAuthorizedException("Admin 권한이 없습니다", ErrorCode.UNAUTHORIZED_EXCEPTION);
        }

        try {
            Long id = Long.valueOf(studentId);
            if (!userRepository.existsById(id)) {
                throw new NotFoundException("학생을 찾을 수 없습니다", ErrorCode.NOT_FOUND_EXCEPTION);
            }
            userRepository.deleteById(id);
        } catch (NumberFormatException e) {
            throw new BadRequestException("유효하지 않은 학생 ID 형식입니다", ErrorCode.BAD_REQUEST_EXCEPTION);
        }
    }


    private void setJwtTokenInHeader(Long id, String role, HttpServletResponse response) {
        String accessToken = jwtTokenProvider.createAccessToken(id, role);
        String refreshToken = jwtTokenProvider.createRefreshToken(id, role);

        jwtTokenProvider.setHeaderAccessToken(response, accessToken);
        jwtTokenProvider.setHeaderRefreshToken(response, refreshToken);

    }
}
