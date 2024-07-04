package dev.oth.cheq.wutils


/**
 * cheq
 * Created by isaac on 2023/11/22.
 */

class WebviewUtils {
    fun getFileNameFromContentDisposition(contentDisposition: String) : String {
        val fileName = contentDisposition.replace(" ", "")
        val fileNameArr = fileName.split(";")

        for (name in fileNameArr) {
            if (name.startsWith("filename")) {
                return name.substring(10, name.length - 1)
            }
        }
        return ""
    }
}