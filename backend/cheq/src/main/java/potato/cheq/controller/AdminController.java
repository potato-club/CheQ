package potato.cheq.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import potato.cheq.dto.admin.RequestAdminLoginDto;
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

//    @PutMapping("/update/{id}")
//    @Operation(summary = "사용자 정보 수정")
//    public ResponseEntity<String> updateAdmin(@PathVariable Long id, @RequestBody UpdateAdminDto updateAdminDto) {
//        return adminService.updateAdmin(id, updateAdminDto);
//    }
//
//    @DeleteMapping("/delete/{id}")
//    @Operation(summary = "사용자 삭제")
//    public ResponseEntity<String> deleteAdmin(@PathVariable Long id) {
//        return adminService.deleteAdmin(id);
//    }
}
