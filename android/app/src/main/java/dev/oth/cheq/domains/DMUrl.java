package dev.oth.cheq.domains;

/**
 * Created By isaacjang on 2023/06/20
 */
public class DMUrl {

    public DMUrl(String url) {
        this.url = url;
    }

    String url;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @Override
    public String toString() {
        return "DMUrl{" +
                "url='" + url + '\'' +
                '}';
    }
}
