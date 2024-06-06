package potato.cheq.service;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import potato.cheq.dto.admin.RequestAdminLoginDto;
import potato.cheq.dto.admin.UpdateAdminDto;
import potato.cheq.entity.AdminEntity;
import potato.cheq.error.security.requestError.NotFoundException;
import potato.cheq.repository.AdminRepository;
import potato.cheq.service.jwt.JwtTokenProvider;
import potato.cheq.service.jwt.RedisService;
import potato.cheq.error.security.ErrorCode;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final RedisService redisService;
    private final JwtTokenProvider jwtTokenProvider;
    private final AdminRepository adminRepository;
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

    public ResponseEntity<String> updateAdmin(Long id, UpdateAdminDto updateAdminDto) {
        AdminEntity admin = adminRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Admin not found", ErrorCode.NOT_FOUND_EXCEPTION));

        admin.updateInfo(updateAdminDto.getEmail(), passwordEncoder.encode(updateAdminDto.getPassword()), updateAdminDto.getTelephoneNumber());
        adminRepository.save(admin);

        return ResponseEntity.ok("Admin 정보 수정 성공");
    }

    public ResponseEntity<String> deleteAdmin(Long id) {
        adminRepository.deleteById(id);
        return ResponseEntity.ok("Admin 삭제 성공");
    }

    private void setJwtTokenInHeader(Long id, String role, HttpServletResponse response) throws Exception {
        String accessToken = jwtTokenProvider.createAccessToken(id, role);
        String refreshToken = jwtTokenProvider.createRefreshToken(id, role);

        jwtTokenProvider.setHeaderAccessToken(response, accessToken);
        jwtTokenProvider.setHeaderRefreshToken(response, refreshToken);

        redisService.setValues(id, refreshToken);
    }
}
