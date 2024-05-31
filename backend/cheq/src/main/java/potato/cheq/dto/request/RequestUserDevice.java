package potato.cheq.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import potato.cheq.entity.UuidEntity;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RequestUserDevice {
    private String device_uuid;

    @Builder
    public UuidEntity toEntity() {
        return UuidEntity.builder()
                .deviceUuid(device_uuid)
                .build();
    }
}
