package dev.oth.cheq.domains;

/**
 * Created By isaacjang on 2023/06/20
 */
public class DMTelNumber {
    String number;

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    @Override
    public String toString() {
        return "{\"DMTelPhone\":{"
                + "\"number\":\"" + number + "\""
                + "}}";
    }
}
