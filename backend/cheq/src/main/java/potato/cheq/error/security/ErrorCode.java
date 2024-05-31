package potato.cheq.error.security;

import lombok.Getter;
import lombok.ToString;
import org.springframework.http.HttpStatus;

@Getter
@ToString
public enum ErrorCode {

    UUID_IS_NULL(HttpStatus.OK, "1000","1000 OK BUT UUID IS NULL"),
    RUNTIME_EXCEPTION(HttpStatus.BAD_REQUEST, "400","400 BAD REQUEST"),
    ACCESS_DENIED_EXCEPTION(HttpStatus.UNAUTHORIZED,"401","401 UNAUTHORIZED"),
    FORBIDDEN_EXCEPTION(HttpStatus.FORBIDDEN,"403","403 FORBIDDEN"),
    NOT_FOUND_EXCEPTION(HttpStatus.NOT_FOUND,"404","404 NOT FOUND"),
    INVALID_TOKEN_EXCEPTION(HttpStatus.UNAUTHORIZED, "401_Invalid", "Invalid access: token in blacklist"),
    INTERNAL_SERVER_EXCEPTION(HttpStatus.INTERNAL_SERVER_ERROR, "500", "500 SERVER ERROR"),
    EXPIRED_REFRESH_TOKEN(HttpStatus.UNAUTHORIZED,"1006","1006 EXPIRED REFRESH TOKEN"),
    EXPIRED_ACCESS_TOKEN(HttpStatus.UNAUTHORIZED,"1007","1007 EXPIRED ACCESS TOKEN");


    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

    ErrorCode(HttpStatus httpStatus, String code, String message) {
        this.httpStatus = httpStatus;
        this.code = code;
        this.message = message;
    }
}