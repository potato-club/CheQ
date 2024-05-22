package potato.cheq.error.security.requestError;

import potato.cheq.error.security.ErrorCode;

public class NotFoundException extends BusinessException {

    public NotFoundException(String message, ErrorCode errorCode) {
        super(message, errorCode);
    }

}