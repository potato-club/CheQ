package potato.cheq.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum ChapelKind {

    CHAPEL3(3,"일반채플"),
    CHAPEL7(7,"일반채플"),
    CHAPEL5(5,"신학채플");

    private final int period;
    private final String chapel;

}
