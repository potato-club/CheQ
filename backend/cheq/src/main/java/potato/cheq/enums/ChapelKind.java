package potato.cheq.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;

@Getter
@RequiredArgsConstructor
public enum ChapelKind {

    CHAPEL3(3,"일반채플","11:03","11:40","11:10"),
    CHAPEL7(7,"일반채플","15:03","15:40","15:10"),
    CHAPEL5(5,"신학채플","13:03","14:40","13:10");

    private final int period;
    private final String chapel;
    private final String startTime;
    private final String endTime;
    private final String tardyTime;

}
