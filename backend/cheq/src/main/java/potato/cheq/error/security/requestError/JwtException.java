package potato.cheq.error.security.requestError;

import potato.cheq.error.security.ErrorCode;

public class JwtException extends BusinessException {

    public JwtException(String message, ErrorCode errorCode) {
        super(message, errorCode);
    }

}