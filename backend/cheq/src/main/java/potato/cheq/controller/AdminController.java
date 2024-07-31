package potato.cheq.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import potato.cheq.dto.admin.RequestAdminLoginDto;

import potato.cheq.dto.admin.RequestUpdateStudentDto;
import potato.cheq.dto.admin.StudentListResponseDto;
import potato.cheq.service.AdminService;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/admin")
@Tag(name = "AdminController", description = "Admin's API")
public class AdminController {

    private final AdminService adminService;

    @PostMapping("/login")
    @Operation(summary = "관리자 로그인")
    public ResponseEntity<Map<String, String>> adminLogin(@RequestBody RequestAdminLoginDto requestDto, HttpServletResponse response) throws Exception {
        Map<String, String> tokens = adminService.adminLogin(requestDto, response);
        return ResponseEntity.ok(tokens);
    }

    @PutMapping("/update/{userId}")
    @Operation(summary = "학생 정보 수정")
    public ResponseEntity<String> updateStudent(@RequestBody RequestUpdateStudentDto updateStudentDto, HttpServletRequest request, @PathVariable("userId") Long userId) throws Exception {
        adminService.updateStudent(updateStudentDto, request, userId);
        return ResponseEntity.ok().body("학생 정보 수정 완료");
    }

    @DeleteMapping("/delete/{studentId}")
    @Operation(summary = "학생 삭제")
    public ResponseEntity<String> deleteStudent(HttpServletRequest request, @PathVariable("studentId") String studentId) throws Exception {
        adminService.deleteStudent(request, studentId);
        return ResponseEntity.ok().body("학생 정보 삭제 완료");
    }

    @GetMapping("/view")
    @Operation(summary = "학생 정보 조회")
    public ResponseEntity<Page<StudentListResponseDto>> viewStudent(
            @RequestParam(value = "page", required = false) int page,
            HttpServletRequest request) throws Exception {
        Page<StudentListResponseDto> result = adminService.viewStudent(page, request);  // 서비스 호출
        return ResponseEntity.ok(result);
    }
}
