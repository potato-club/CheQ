package dev.oth.cheq.domains;

/**
 * Created By isaacjang on 2023/06/20
 */
public class DMSetBgColor {
    Boolean isLight;
    String color;

    public Boolean getLight() {
        return isLight;
    }

    public void setLight(Boolean light) {
        isLight = light;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    @Override
    public String toString() {
        return "{\"DMSetBgColor\":{"
                + "\"isLight\":\"" + isLight + "\""
                + ", \"color\":\"" + color + "\""
                + "}}";
    }
}
