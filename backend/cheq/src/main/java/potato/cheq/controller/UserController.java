package potato.cheq.controller;

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

//    @GetMapping("/manager")
//    public ResponseEntity<String> enterManagerPage(@RequestBody )

    // 로그인은 login.do api 써도되나? 이거에따라 nfc, 비콘 로직 설계가 바뀔듯

    @PostMapping("/device") // 기기 등록 api 추후 다른 값들 추가
    public Long saveUserDevice(@RequestBody RequestUserDevice dto) throws Exception {
        return userService.setUserDevice(dto);
    }

//    @PostMapping("/nfc")
//    @ResponseStatus(HttpStatus.OK)
//    public void checkNFC(@RequestBody NFCRequestDto){
//        userService.
//    }


}
