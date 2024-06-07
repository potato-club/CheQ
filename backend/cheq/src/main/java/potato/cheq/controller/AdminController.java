package potato.cheq.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import potato.cheq.dto.admin.RequestAdminLoginDto;
import potato.cheq.dto.admin.RequestUpdateStudentDto;
import potato.cheq.dto.admin.UpdateAdminDto;
import potato.cheq.service.AdminService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/admin")
@Tag(name = "AdminController", description = "Admin's API")
public class AdminController {

    private final AdminService adminService;

    @PostMapping("/login")
    @Operation(summary = "관리자 로그인")
    public ResponseEntity<String> adminLogin(@RequestBody RequestAdminLoginDto requestDto, HttpServletResponse response) throws Exception {
        return adminService.adminLogin(requestDto, response);
    }

//    @PutMapping("/update/{userId}")
//    @Operation(summary = "학생 정보 수정")
//    public ResponseEntity<String> updateStudent(HttpServletRequest request, @PathVariable Long userId, @RequestBody RequestUpdateStudentDto updateStudentDto) throws Exception {
//       return adminService.updateStudent(request, userId, updateStudentDto);
//    }

//    @DeleteMapping("/student/{studentId}")
//    @Operation(summary = "학생 삭제")
//    public ResponseEntity<String> deleteStudent(HttpServletRequest request, @PathVariable Long studentId) throws Exception {
//        return adminService.deleteStudent(request, studentId);
//    }
}
