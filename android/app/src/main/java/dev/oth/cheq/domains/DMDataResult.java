package dev.oth.cheq.domains;

/**
 * Created By isaacjang on 2023/07/10
 */
public class DMDataResult {
    private BaseResultDomain result;
    private String data;

    public BaseResultDomain getResult() {
        return result;
    }

    public void setResult(BaseResultDomain result) {
        this.result = result;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public DMDataResult(BaseResultDomain result, String data) {
        this.result = result;
        this.data = data;
    }

    @Override
    public String toString() {
        return "{\"DMCameraResult\":{"
                + "\"result\":" + result
                + ", \"data\":\"" + data + "\""
                + "}}";
    }
}
