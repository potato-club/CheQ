package dev.oth.cheq.utils

/**
 * Created By isaacjang on 2023/06/20
 */
class SimpleUtils {

    public fun recipeSerialize(list: List<String>) : String {
        var result = ""
        for (item in list) {
            if (result.isNotEmpty()) {
                result += ";"
            }
            result += item
        }
        return result
    }
}