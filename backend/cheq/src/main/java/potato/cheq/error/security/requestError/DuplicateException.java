package potato.cheq.error.security.requestError;

import potato.cheq.error.security.ErrorCode;

public class DuplicateException extends BusinessException {

    public DuplicateException(String message, ErrorCode errorCode) {
        super(message, errorCode);
    }

}