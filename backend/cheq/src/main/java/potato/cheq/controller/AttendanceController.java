package potato.cheq.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import potato.cheq.dto.NFCRequestDto;
import potato.cheq.service.AttendanceService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/attendance")
@Tag(name = "AttendanceController", description = "Attendance's API")
public class AttendanceController {

    private final AttendanceService attendanceService;

    // 찍었을때 날라오는 회원의 기기값과, 토큰의 기기값이 같으면 ok
    @PostMapping("/nfc")
    @Operation(summary = "nfc 출결 API")
    public ResponseEntity<String> checkAttendanceByNFC(HttpServletRequest request, @RequestBody NFCRequestDto nfcRequestDto) throws Exception {
        String macAddress = attendanceService.checkAttendanceByNfcService(request, nfcRequestDto);
        return ResponseEntity.ok().body(macAddress + "기기 NFC 태그");
    }

}
