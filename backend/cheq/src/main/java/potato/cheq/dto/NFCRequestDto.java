package potato.cheq.dto;

import lombok.Builder;
import lombok.Data;
import potato.cheq.entity.NFCEntity;

import java.time.LocalDateTime;

@Data
public class NFCRequestDto {
    private String mac_address;
    private String nfc_position;
    private LocalDateTime attendanceTime;

    @Builder
    public NFCEntity toEntity() {
        return NFCEntity.builder()
                .mac_address(mac_address)
                .nfc_position(nfc_position)
                .build();
    }

}
