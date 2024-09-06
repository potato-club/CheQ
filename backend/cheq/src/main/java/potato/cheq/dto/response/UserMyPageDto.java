package potato.cheq.dto.response;

import io.swagger.v3.oas.annotations.info.Contact;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class UserMyPageDto {
    private String email;
    private String studentId;
    private String seat;
    private String major;

}
