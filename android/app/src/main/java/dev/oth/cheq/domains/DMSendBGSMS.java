package dev.oth.cheq.domains;

import java.util.ArrayList;

/**
 * Created By isaacjang on 2023/06/20
 */
public class DMSendBGSMS {
    ArrayList<DMSingleSMS> list = new ArrayList<>();

    public ArrayList<DMSingleSMS> getList() {
        return list;
    }

    public void setList(ArrayList<DMSingleSMS> list) {
        this.list = list;
    }

    @Override
    public String toString() {
        return "DMSendBGSMS{" +
                "list=" + list +
                '}';
    }
}
