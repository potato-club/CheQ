package dev.oth.cheq.domains;

/**
 * Created By isaacjang on 2023/07/20
 */
public class PushRecieveRequest {

    public String token;
    public String msgId;
    public String rcvDtm;

    public PushRecieveRequest(String token, String msgId, String rcvDtm) {
        this.token = token;
        this.msgId = msgId;
        this.rcvDtm = rcvDtm;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getMsgId() {
        return msgId;
    }

    public void setMsgId(String msgId) {
        this.msgId = msgId;
    }

    public String getRcvDtm() {
        return rcvDtm;
    }

    public void setRcvDtm(String rcvDtm) {
        this.rcvDtm = rcvDtm;
    }

    @Override
    public String toString() {
        return "{\"RecievePushRequest\":{"
                + "\"token\":\"" + token + "\""
                + ", \"msgId\":\"" + msgId + "\""
                + ", \"rcvDtm\":\"" + rcvDtm + "\""
                + "}}";
    }
}



