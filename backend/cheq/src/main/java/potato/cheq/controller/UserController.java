package potato.cheq.controller;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import potato.cheq.dto.NFCRequestDto;
import potato.cheq.dto.RequestUserDevice;
import potato.cheq.dto.RequestUserDto;
import potato.cheq.service.UserService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {

    private final UserService userService;

    @PostMapping("/join") // 사용자 회원가입 api
    public Long saveUserData(@RequestBody RequestUserDto dto) throws Exception {
        return userService.setUserData(dto);
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody RequestUserDto dto, HttpServletResponse response) throws Exception {
        return userService.login(dto, response);
    }

    @PostMapping("/device") // 기기 등록 api 추후 다른 값들 추가
    public Long saveUserDevice(@RequestBody RequestUserDevice dto) throws Exception {
        return userService.setUserDevice(dto);
    }

}
