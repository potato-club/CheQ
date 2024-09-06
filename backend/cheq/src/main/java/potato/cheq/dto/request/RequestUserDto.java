package potato.cheq.dto.request;

import lombok.Builder;
import lombok.Data;
import potato.cheq.entity.UserEntity;
import potato.cheq.enums.ChapelKind;
import potato.cheq.enums.UserRole;

@Data
@Builder
public class RequestUserDto {

    private String email; // 이메일
    private String studentId; // 학번
    private String seat;
    private String uuid;
    private ChapelKind chapelKind;
    private String major;

    @Builder
    public UserEntity toEntity() {
        return UserEntity.builder()
                .email(email)
                .studentId(studentId)
                .seat(seat)
                .stUuid(uuid)
                .userRole(UserRole.USER)
                .chapelKind(chapelKind)
                .major(major)
                .build();
    }

}
