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
import potato.cheq.dto.request.BeaconRequestDto;
import potato.cheq.dto.request.NFCRequestDto;
import potato.cheq.service.AttendanceService;


@RestController
@RequiredArgsConstructor
@RequestMapping("/attendance")
@Tag(name = "AttendanceController", description = "Attendance's API")
public class AttendanceController {

    private final AttendanceService attendanceService;

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



}
