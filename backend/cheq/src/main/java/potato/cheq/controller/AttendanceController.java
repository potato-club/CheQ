package potato.cheq.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import potato.cheq.dto.request.BeaconRequestDto;
import potato.cheq.dto.request.NFCRequestDto;
import potato.cheq.dto.response.AttendanceDto;
import potato.cheq.error.security.ErrorCode;
import potato.cheq.error.security.requestError.UnAuthorizedException;
import potato.cheq.service.AttendanceService;
import potato.cheq.service.jwt.JwtTokenProvider;

import java.util.List;


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
        if (uuid == null) {
            throw new UnAuthorizedException("기기 정보가 일치하지 않습니다.", ErrorCode.INVALID_TOKEN_EXCEPTION);
        }
        return ResponseEntity.ok().body(uuid + " 기기 NFC 태그");
    }

    @PostMapping("/beacon")
    @Operation(summary = "beacon 출결 API")
    public ResponseEntity<String> checkAttendanceByBeacon(HttpServletRequest request, @RequestBody BeaconRequestDto beaconRequestDto) throws Exception {
        String uuid = attendanceService.checkAttendanceByBeaconService(request, beaconRequestDto);
        if (uuid == null) {
            throw new UnAuthorizedException("기기 정보가 일치하지 않습니다.", ErrorCode.INVALID_TOKEN_EXCEPTION);
        }
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

    @GetMapping("/all")
    public ResponseEntity<List<AttendanceDto>> getAttendanceByDate(HttpServletRequest request) throws Exception {
        List<AttendanceDto> attendanceByDate = attendanceService.getAttendanceByDate(request);
        return ResponseEntity.ok(attendanceByDate);
    }

}
