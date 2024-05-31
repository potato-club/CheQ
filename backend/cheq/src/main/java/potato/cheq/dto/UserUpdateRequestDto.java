package potato.cheq.dto;

import lombok.Builder;
import lombok.Data;
import potato.cheq.entity.UserEntity;

@Data
public class UserUpdateRequestDto {
    private String email;
    private String seat;

    @Builder
    public UserEntity toEntity() {
        return UserEntity.builder()
                .email(email)
                .seat(seat)
                .build();
    }

}
