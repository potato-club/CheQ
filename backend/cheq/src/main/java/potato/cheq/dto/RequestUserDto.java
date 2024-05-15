package potato.cheq.dto;

import lombok.Builder;
import lombok.Data;
import potato.cheq.entity.UserEntity;
import potato.cheq.enums.ChapelKind;

@Data
@Builder
public class RequestUserDto {

    private String email; // 이메일
    private String studentId; // 학번
    private String seat;
    private String uuid;
//    private ChapelKind chapelKind;

    @Builder
    public UserEntity toEntity() {
        return UserEntity.builder()
                .email(email)
                .studentId(studentId)
                .seat(seat)
                .uuid(uuid)
//                .chapelKind(chapelKind)
                .build();
    }

}
