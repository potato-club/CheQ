package potato.cheq.dto.admin;

import com.querydsl.core.annotations.QueryProjection;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
public class StudentListResponseDto {
    private String studentId;
    private String chapelKind;
    private String seat;
    private String major;

    @QueryProjection
    public StudentListResponseDto(String studentId, String chapelKind, String seat, String major) {
        this.studentId = studentId;
        this.chapelKind = chapelKind;
        this.seat = seat;
        this.major = major;
    }


}
