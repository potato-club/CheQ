package potato.cheq.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

    @PostMapping("/input")
    public ResponseEntity.BodyBuilder getUserData() {
        return ResponseEntity.status(HttpStatus.OK);
    }
}
