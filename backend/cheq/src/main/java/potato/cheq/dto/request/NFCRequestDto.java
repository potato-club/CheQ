package potato.cheq.dto.request;

import lombok.Builder;
import lombok.Data;
import potato.cheq.entity.NFCEntity;

import java.time.LocalDateTime;

@Data
public class NFCRequestDto {
    private String uuid;
    private String nfc_position;
    private LocalDateTime attendanceTime;

    @Builder
    public NFCEntity toEntity() {
        return NFCEntity.builder()
                .uuid(uuid)
                .nfc_position(nfc_position)
                .build();
    }

}
