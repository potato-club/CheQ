package dev.oth.cheq.domains;

import java.util.Map;

/**
 * Created By isaacjang on 2023/07/10
 */
public class DMDataMapResult {
    private BaseResultDomain result;
    private Map<String, String> data;

    public BaseResultDomain getResult() {
        return result;
    }

    public void setResult(BaseResultDomain result) {
        this.result = result;
    }

    public Map<String, String> getData() {
        return data;
    }

    public void setData(Map<String, String> data) {
        this.data = data;
    }

    public DMDataMapResult(BaseResultDomain result, Map<String, String> data) {
        this.result = result;
        this.data = data;
    }

    @Override
    public String toString() {
        return "{\"DMDataObjectResult\":{"
                + "\"result\":" + result
                + ", \"data\":" + data
                + "}}";
    }
}
