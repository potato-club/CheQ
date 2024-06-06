package potato.cheq.dto.admin;

import lombok.Data;
import potato.cheq.enums.ChapelKind;

@Data
public class RequestUpdateStudentDto {
    private String studentId;
    private String seat;
    private String chapelKind;

}
