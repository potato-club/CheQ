package potato.cheq.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import potato.cheq.dto.request.BeaconRequestDto;
import potato.cheq.dto.request.NFCRequestDto;
import potato.cheq.service.AttendanceService;
import potato.cheq.service.jwt.JwtTokenProvider;


@RestController
@RequiredArgsConstructor
@RequestMapping("/attendance")
@Tag(name = "AttendanceController", description = "Attendance's API")
public class AttendanceController {

    private final AttendanceService attendanceService;
    private final JwtTokenProvider jwtTokenProvider;

    @PostMapping("/nfc")
    @Operation(summary = "nfc 출결 API")
    public ResponseEntity<String> checkAttendanceByNFC(HttpServletRequest request, @RequestBody NFCRequestDto nfcRequestDto) throws Exception {
        String uuid = attendanceService.checkAttendanceByNfcService(request, nfcRequestDto);
        return ResponseEntity.ok().body(uuid + " 기기 NFC 태그");
    }

    @PostMapping("/beacon")
    @Operation(summary = "beacon 출결 API")
    public ResponseEntity<String> checkAttendanceByBeacon(HttpServletRequest request, @RequestBody BeaconRequestDto beaconRequestDto) throws Exception {
        String uuid = attendanceService.checkAttendanceByBeaconService(request, beaconRequestDto);
        return ResponseEntity.ok().body(uuid + " 기기 Beacon 출결");
    }

    @GetMapping("/check")
    @Operation(summary = "출결 정보")
    public ResponseEntity<String> checkAttendance(HttpServletRequest request) throws Exception {
        String token = jwtTokenProvider.resolveAccessToken(request);
        String studentId = jwtTokenProvider.extractMemberId(token);
        boolean isAttendanceValid = attendanceService.checkAttendance(request);
        if (isAttendanceValid) {
            return ResponseEntity.ok().body(studentId + "학생 출결 완료");
        }
        return ResponseEntity.ok().body(studentId + "학생 미출결");
    }

    @GetMapping("/tardy")
    @Operation(summary = "지각 정보")
    public Long checkStatus(HttpServletRequest request) throws Exception {
        return attendanceService.determineAttendanceStatus(request);
    }


}
