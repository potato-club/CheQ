package potato.cheq.error.security.requestError;

import potato.cheq.error.security.ErrorCode;

public class InvalidTokenException extends BusinessException {

    public InvalidTokenException(String message, ErrorCode errorCode) {
        super(message, errorCode);
    }

}