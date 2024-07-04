package dev.oth.cheq.domains;

/**
 * Created By isaacjang on 2023/06/20
 */
public class DMDownloadApk {

    public DMDownloadApk(String apkUrl) {
        this.apkUrl = apkUrl;
    }

    String apkUrl;

    public String getApkUrl() {
        return apkUrl;
    }

    public void setApkUrl(String apkUrl) {
        this.apkUrl = apkUrl;
    }

    @Override
    public String toString() {
        return "{\"DMDownloadApk\":{"
                + "\"apkUrl\":\"" + apkUrl + "\""
                + "}}";
    }
}
