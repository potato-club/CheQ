package dev.oth.cheq.domains;

/**
 * Created By isaacjang on 2023/07/10
 */
public class BaseResultDomain {
    private String resultMessage;
    private boolean resultBoolean;

    public BaseResultDomain(String resultMessage, boolean resultBoolean) {
        this.resultMessage = resultMessage;
        this.resultBoolean = resultBoolean;
    }

    public String getResultMessage() {
        return resultMessage;
    }

    public void setResultMessage(String resultMessage) {
        this.resultMessage = resultMessage;
    }

    public boolean isResultBoolean() {
        return resultBoolean;
    }

    public void setResultBoolean(boolean resultBoolean) {
        this.resultBoolean = resultBoolean;
    }

    @Override
    public String toString() {
        return "{\"BaseResultDomain\":{"
                + "\"resultMessage\":\"" + resultMessage + "\""
                + ", \"resultBoolean\":\"" + resultBoolean + "\""
                + "}}";
    }
}
