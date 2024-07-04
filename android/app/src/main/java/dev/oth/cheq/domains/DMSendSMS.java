package dev.oth.cheq.domains;

import java.util.ArrayList;
import java.util.List;

/**
 * Created By isaacjang on 2023/06/20
 */
public class DMSendSMS {
    List<String> recipients = new ArrayList<>();
    String desc;

    public List<String> getRecipients() {
        return recipients;
    }

    public void setRecipients(List<String> recipients) {
        this.recipients = recipients;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    @Override
    public String toString() {
        return "{\"SendSMS\":{"
                + "\"recipients\":" + recipients
                + ", \"desc\":\"" + desc + "\""
                + "}}";
    }
}
