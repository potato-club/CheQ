package dev.oth.cheq.domains;

/**
 * Created By isaacjang on 2023/06/20
 */
public class DMVersionCheck {
    String appVerNm;
    String downloadUrl;

    public String getAppVerNm() {
        return appVerNm;
    }

    public void setAppVerNm(String appVerNm) {
        this.appVerNm = appVerNm;
    }

    public String getDownloadUrl() {
        return downloadUrl;
    }

    public void setDownloadUrl(String downloadUrl) {
        this.downloadUrl = downloadUrl;
    }

    @Override
    public String toString() {
        return "DMVersionCheck{" +
                "appVerNm='" + appVerNm + '\'' +
                ", downloadUrl='" + downloadUrl + '\'' +
                '}';
    }
}
