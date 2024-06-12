package potato.cheq.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ChapelKindDto {
    private int period;
    private String chapel;
    private String startTime;
    private String endTime;
    private String tardyTime;
}
