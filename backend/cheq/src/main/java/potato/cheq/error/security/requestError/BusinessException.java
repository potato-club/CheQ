package potato.cheq.error.security.requestError;

import lombok.Getter;
import potato.cheq.error.security.ErrorCode;

@Getter
public class BusinessException extends RuntimeException{

    private final ErrorCode errorCode;

    public BusinessException(String message, ErrorCode errorCode) {
        super(message);
        this.errorCode = errorCode;
    }
}