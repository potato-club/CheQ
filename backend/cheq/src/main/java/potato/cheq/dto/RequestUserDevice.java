package potato.cheq.dto;

import lombok.Builder;
import lombok.Data;
import potato.cheq.entity.UserEntity;

@Data
public class RequestUserDevice {
    private String uuid;

    @Builder
    public UserEntity toEntity() {
        return UserEntity.builder()
                .uuid(uuid)
                .build();
    }
}
