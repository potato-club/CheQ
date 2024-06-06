package potato.cheq.dto.request;

import lombok.Builder;
import lombok.Data;
import potato.cheq.entity.BeaconEntity;
import potato.cheq.entity.NFCEntity;

import java.time.LocalDateTime;

@Data

public class BeaconRequestDto {

    private String uuid;
    private String beacon_position;
    private LocalDateTime attendanceTime;

    @Builder
    public BeaconEntity toEntity() {
        return BeaconEntity.builder()
                .uuid(uuid)
                .beacon_position(beacon_position)
                .build();
    }
}
