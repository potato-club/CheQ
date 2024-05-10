package potato.cheq.dto;

import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class NFCResponseDto {

    private String mac_address;
    private String NFC_position;
    private LocalDateTime attendance_time;
}
