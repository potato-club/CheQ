package dev.oth.cheq.utils

import android.webkit.WebView
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine

/**
 * Created By isaacjang on 2023/07/25
 */
class JSCodeAsync(var webView: WebView, var function: String) : ViewModel() {
    interface JsResult {
        fun result(result: String)
    }

    private var postJob: Job? = null

    private fun realPost(resultCallback: JsResult) {
        postJob = viewModelScope.launch {
            webView.evaluateJavascript(function) {
                resultCallback.result(it)
            }
        }
    }

    suspend fun post(): String {
        val result = suspendCancellableCoroutine { continuation ->
            val callbackImpl = object : JsResult {
                override fun result(result: String) {
                    continuation.resume(result) {
                        it.printStackTrace()
                    }
                }
            }
            realPost(callbackImpl)
        }
        return result
    }
}