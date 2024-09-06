package potato.cheq.dto.request;

import lombok.Builder;
import lombok.Data;
import potato.cheq.entity.UserEntity;
import potato.cheq.enums.ChapelKind;

@Data
@Builder
public class UserUpdateRequestDto {
    private String email;
    private String seat;
    private ChapelKind chapelKind;
    private String major;


}
