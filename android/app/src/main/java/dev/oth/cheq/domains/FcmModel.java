package dev.oth.cheq.domains;

import java.io.Serializable;

/**
 * Created By isaacjang on 2023/07/20
 */
public class FcmModel implements Serializable {
    public String msgId;
    public String extrUrlInfo;
    public String urlInfo;
    public String imgUrl;
    public int badgeCnt;
    public String title;
    public String content;
    public String cmdTypeCode;

    public String getMsgId() {
        return msgId;
    }

    public void setMsgId(String msgId) {
        this.msgId = msgId;
    }

    public String getUrlInfo() {
        return urlInfo;
    }

    public void setUrlInfo(String urlInfo) {
        this.urlInfo = urlInfo;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public int getBadgeCnt() {
        return badgeCnt;
    }

    public void setBadgeCnt(int badgeCnt) {
        this.badgeCnt = badgeCnt;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCmdTypeCode() {
        return cmdTypeCode;
    }

    public void setCmdTypeCode(String cmdTypeCode) {
        this.cmdTypeCode = cmdTypeCode;
    }

    public String getExtrUrlInfo() {
        return extrUrlInfo;
    }

    public void setExtrUrlInfo(String extrUrlInfo) {
        this.extrUrlInfo = extrUrlInfo;
    }

    @Override
    public String toString() {
        return "FcmModel{" +
                "msgId='" + msgId + '\'' +
                ", extrUrlInfo='" + extrUrlInfo + '\'' +
                ", urlInfo='" + urlInfo + '\'' +
                ", imgUrl='" + imgUrl + '\'' +
                ", badgeCnt=" + badgeCnt +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", cmdTypeCode='" + cmdTypeCode + '\'' +
                '}';
    }
}

