package potato.cheq.error.security.requestError;

import potato.cheq.error.security.ErrorCode;

public class ForbiddenException extends BusinessException {

    public ForbiddenException(String message, ErrorCode errorCode) {
        super(message, errorCode);
    }

}