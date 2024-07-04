package dev.oth.cheq.domains;

import java.util.List;

/**
 * Created By isaacjang on 2023/06/20
 */
public class DMTypeListModel {

    //types : ocr...

    List<String> types;

    public List<String> getTypes() {
        return types;
    }

    public void setTypes(List<String> types) {
        this.types = types;
    }

    @Override
    public String toString() {
        return "{\"DMTypeListModel\":{"
                + "\"types\":" + types
                + "}}";
    }
}
