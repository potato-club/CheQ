package dev.oth.cheq.responses;

/**
 * Created By isaacjang on 2023/07/20
 */
public class BaseResponseModel {
    NetHeader header;

    public NetHeader getHeader() {
        return header;
    }

    public void setHeader(NetHeader header) {
        this.header = header;
    }

    @Override
    public String toString() {
        return "{\"BaseResponseModel\":{"
                + "\"header\":" + header
                + "}}";
    }
}
