package potato.cheq.error.security.requestError;

import potato.cheq.error.security.ErrorCode;

public class BadRequestException extends BusinessException {

    public BadRequestException(String message, ErrorCode errorCode) {
        super(message, errorCode);
    }
}