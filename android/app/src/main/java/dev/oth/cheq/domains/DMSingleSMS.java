package dev.oth.cheq.domains;

/**
 * Created By isaacjang on 2023/06/20
 */
public class DMSingleSMS {
    public String recipient;
    public String desc;

    public String getRecipient() {
        return recipient;
    }

    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    @Override
    public String toString() {
        return "DMSingleSMS{" +
                "recipients='" + recipient + '\'' +
                ", desc='" + desc + '\'' +
                '}';
    }
}
