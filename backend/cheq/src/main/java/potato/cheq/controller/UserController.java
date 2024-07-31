package potato.cheq.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import potato.cheq.dto.request.RequestLoginDto;
import potato.cheq.dto.request.RequestUpdateUserDto;
import potato.cheq.dto.request.RequestUserDto;
import potato.cheq.dto.response.UserMyPageDto;
import potato.cheq.dto.request.UserUpdateRequestDto;
import potato.cheq.service.UserService;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
@Tag(name = "UserController", description = "User's API")
public class UserController {

    private final UserService userService;

    @PostMapping("/join") // 사용자 회원가입 api
    @Operation(summary = "회원 등록 (추후 관리자만 사용 가능)")
    public Long saveUserData(@RequestBody RequestUserDto dto){
        return userService.setUserData(dto);
    }

    @PostMapping("/login") // 학번만 입력시 토큰 발급 완료
    @Operation(summary = "사용자 로그인 (학번만 입력)")
    public ResponseEntity<Map<String,String>> login(@RequestBody RequestLoginDto dto, HttpServletResponse response) throws Exception {
        Map<String, String> tokens = userService.login(dto, response);
        return ResponseEntity.ok(tokens);
    }

    @PutMapping("/device/{id}")
    @Operation(summary = "회원 정보 수정(기기등록)")
    public ResponseEntity<String> addUserDevice(@RequestBody RequestUpdateUserDto dto, @PathVariable("id") Long id, HttpServletRequest request) throws Exception {
        userService.setUserDevice(request, id, dto);
        return ResponseEntity.ok().body("기기정보가 등록되었습니다."); // 추후 기기정보는 2주에 한번 바꿀 수 있도록 수정
    }

    @GetMapping("/reissue")
    @Operation(summary = "토큰 재발급")
    public ResponseEntity<String> reissueToken(HttpServletRequest request, HttpServletResponse response) {
        userService.reissueToken(request, response);
        return ResponseEntity.ok().body("토큰 재발급 완료");
    }

    @GetMapping("/viewinfo")
    @Operation(summary = "회원 정보 확인")
    public ResponseEntity<UserMyPageDto> getUserInfo(HttpServletRequest request) {
        UserMyPageDto userInfo = userService.viewUserInfo(request);
        return ResponseEntity.ok(userInfo);
    }

     @PutMapping("/")
    @Operation(summary = "회원 정보 수정")
    public ResponseEntity<String> updateUserInfo(@RequestBody UserUpdateRequestDto userUpdateRequestDto, HttpServletRequest request) {
        userService.updateUser(userUpdateRequestDto, request);
        return ResponseEntity.ok("회원 정보 수정 완료");
    }

}
