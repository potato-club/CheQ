package potato.cheq.service;

import com.querydsl.core.QueryResults;
import com.querydsl.core.types.Order;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import potato.cheq.dto.admin.RequestAdminLoginDto;
import potato.cheq.dto.admin.RequestUpdateStudentDto;
import potato.cheq.dto.admin.StudentListResponseDto;
import potato.cheq.entity.AdminEntity;
import potato.cheq.entity.QUserEntity;
import potato.cheq.entity.UserEntity;
import potato.cheq.enums.UserRole;
import potato.cheq.error.security.requestError.BadRequestException;
import potato.cheq.error.security.requestError.NotFoundException;
import potato.cheq.error.security.requestError.UnAuthorizedException;
import potato.cheq.repository.AdminRepository;
import potato.cheq.repository.UserRepository;
import potato.cheq.service.jwt.JwtTokenProvider;
import potato.cheq.error.security.ErrorCode;

import java.nio.file.AccessDeniedException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final JwtTokenProvider jwtTokenProvider;
    private final AdminRepository adminRepository;
    private final UserRepository userRepository;
    private final JPAQueryFactory jpaQueryFactory;


    private final PasswordEncoder passwordEncoder;

    QUserEntity qUserEntity =  QUserEntity.userEntity;


    public Map<String, String>  adminLogin(RequestAdminLoginDto requestDto, HttpServletResponse response) throws Exception {
        AdminEntity admin = adminRepository.findByEmail(requestDto.getEmail())
                .orElseThrow(() -> new NotFoundException("Admin not found", ErrorCode.NOT_FOUND_EXCEPTION));

//        if (!passwordEncoder.matches(requestDto.getPassword(), admin.getPassword())) { // 이부분에서 오류
//            throw new UnAuthorizedException("401", ErrorCode.ACCESS_DENIED_EXCEPTION);
//        }

        String at = setBodyAtToken(requestDto.getEmail(), response);
        String rt = setBodyRtToken(requestDto.getEmail(), response);

        Map<String, String> tokens = new HashMap<>();
        tokens.put("at", at);
        tokens.put("rt", rt);

        return tokens;
    }

    public String setBodyAtToken(String email, HttpServletResponse response) {
        AdminEntity admin = adminRepository.findByEmail(email).orElseThrow();

        UserRole role = admin.getUserRole();

        return jwtTokenProvider.createAccessToken(admin.getId(), role);
    }

    public String setBodyRtToken(String email, HttpServletResponse response) {
        AdminEntity admin = adminRepository.findByEmail(email).orElseThrow();

        UserRole role = admin.getUserRole();

        return jwtTokenProvider.createRefreshToken(admin.getId(), role);
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



    public Page<StudentListResponseDto> viewStudent(int page, HttpServletRequest request) throws Exception {
        String token = jwtTokenProvider.resolveAccessToken(request);
        if (token == null || !jwtTokenProvider.validateAccessToken(token)) {
            throw new UnAuthorizedException("토큰 오류", ErrorCode.UNAUTHORIZED_EXCEPTION);
        }

        String userRole = jwtTokenProvider.extractRole(token);

        if (!userRole.equals("ADMIN")) {
            throw new UnAuthorizedException("Admin 권한이 없습니다", ErrorCode.UNAUTHORIZED_EXCEPTION);
        }

        Sort.Direction direction = Sort.Direction.DESC;
        Pageable pageable = PageRequest.of(page - 1, 10, Sort.by(direction, "createdDate"));


        return executeQuery(pageable, direction);
    }

    private Page<StudentListResponseDto> executeQuery(Pageable pageable, Sort.Direction direction) {
        QueryResults<UserEntity> queryResults = jpaQueryFactory
                .selectFrom(qUserEntity)
                .orderBy(new OrderSpecifier<>(direction.isAscending() ? Order.ASC : Order.DESC, qUserEntity.studentId))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetchResults();

        List<StudentListResponseDto> dtoList = queryResults.getResults().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());

        return new PageImpl<>(dtoList, pageable, queryResults.getTotal());
    }

    private StudentListResponseDto convertToDto(UserEntity entity) {
        return StudentListResponseDto.builder()
                .studentId(entity.getStudentId())
                .chapelKind(String.valueOf(entity.getChapelKind()))
                .seat(entity.getSeat())
                .build();
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


//    private void setJwtTokenInHeader(Long id, String role, HttpServletResponse response) {
//        String accessToken = jwtTokenProvider.createAccessToken(id, role);
//        String refreshToken = jwtTokenProvider.createRefreshToken(id, role);
//
//        jwtTokenProvider.setHeaderAccessToken(response, accessToken);
//        jwtTokenProvider.setHeaderRefreshToken(response, refreshToken);
//
//    }
}
