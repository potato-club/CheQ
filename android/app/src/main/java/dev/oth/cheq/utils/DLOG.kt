package dev.oth.cheq.utils

import android.util.Log
import dev.oth.cheq.BuildConfig

/**
 * @Creator: isaacJang-dev
 * @Date: 2023-01-19
 */

object DLog {
    private const val filter_string = "JIS_"
    private const val VERBOSE = Log.VERBOSE
    private const val DEBUG = Log.DEBUG
    private const val INFO = Log.INFO
    private const val WARN = Log.WARN
    private const val ERROR = Log.ERROR

    public fun v(tag: String? = null, msg: String? = null, tr: Throwable? = null) {
        logginBridge(priority = VERBOSE, tag= tag, msg = msg, tr= tr)
    }

    public fun d(tag: String? = null, msg: String? = null, tr: Throwable? = null) {
        logginBridge(priority = DEBUG, tag= tag, msg = msg, tr= tr)
    }

    public fun i(tag: String? = null, msg: String? = null, tr: Throwable? = null) {
        logginBridge(priority = INFO, tag= tag, msg = msg, tr= tr)
    }

    public fun w(tag: String? = null, msg: String? = null, tr: Throwable? = null) {
        logginBridge(priority = WARN, tag= tag, msg = msg, tr= tr)
    }

    public fun e(tag: String? = null, msg: String? = null, tr: Throwable? = null) {
        logginBridge(priority = ERROR, tag= tag, msg = msg, tr= tr)
    }

    private fun logginBridge(priority: Int, tag: String? = null, msg: String? = null, tr: Throwable? = null) {
        if (!tag.isNullOrEmpty() && msg.isNullOrEmpty()) {
            logging(priority, tag = null, msg = tag, tr)
            return
        }

        logging(priority, tag, msg, tr)
    }

    private const val stackDepth = 6
    private fun logging(priority: Int, tag: String? = null, msg: String? = null, tr: Throwable? = null) {
        if (!BuildConfig.DEBUG) {
            return
        }
        Log.getStackTraceString(tr)

        val msgBuilder = StringBuilder()
        msgBuilder
            .append("(").append(Thread.currentThread().stackTrace[stackDepth].fileName).append(":")
            .append(Thread.currentThread().stackTrace[stackDepth].lineNumber)
            .append(")") //                    .append("[").append(Thread.currentThread().getStackTrace()[4].getFileName().replace(".java", "").replace(".kt", ""))
            .append(" :: ").append(Thread.currentThread().stackTrace[stackDepth].methodName).append("()")
            .append("]")
        if (msg != null) {
            msgBuilder.append(" :").append(" [").append(msg).append("]")
        }

        var fileName = Thread.currentThread().stackTrace[stackDepth].fileName
        if (!fileName.isNullOrEmpty()) {
            fileName = fileName.replace(".java", "").replace(".kt", "")
        }
        if (tag != null) {
            fileName += "[$tag]"
        }

        printLog(priority, fileName, msgBuilder.toString())
    }

    private fun printLog(priority: Int, tag: String, strMssage: String) {
        if(strMssage.length > 2000) {
            Log.println(priority, filter_string + tag, strMssage.substring(0, 2000));
            printLog(priority, tag, strMssage.substring(2000));
        } else {
            Log.println(priority, filter_string + tag, strMssage)
        }
    }

    fun printException(e: Exception) {
        if (BuildConfig.DEBUG) {
            e.printStackTrace()
        }
    }
}