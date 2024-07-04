package dev.oth.cheq.responses;

import java.io.Serializable;

/**
 * Created By isaacjang on 2023/07/20
 */
public class NetHeader implements Serializable {
    public String code;
    public String message;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return "{\"NetHeader\":{"
                + "\"code\":\"" + code + "\""
                + ", \"message\":\"" + message + "\""
                + "}}";
    }
}
