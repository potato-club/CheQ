package potato.cheq.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import potato.cheq.dto.RequestUserDto;
import potato.cheq.service.UserService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {

    private final UserService userService;

    @PostMapping("/join")
    @ResponseStatus(HttpStatus.OK)
    public Long saveUserData(@RequestBody RequestUserDto dto) throws Exception {
        return userService.setUserData(dto);
    }

//    @GetMapping("/get")
//    @ResponseStatus(HttpStatus.OK)
//    public void getUserData()
}
