package dev.oth.cheq.utils

import android.view.View
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine

/**
 * Created By isaacjang on 2023/07/25
 */
class ViewPostAsync(private val originView : View) : ViewModel() {
    interface NetworkResult {
        fun result(view: View)
    }

    private var postJob: Job? = null

    private fun realPost(resultCallback: NetworkResult) {
        postJob = viewModelScope.launch {
            originView.post {
                resultCallback.result(originView)
            }
        }
    }

    suspend fun post(): View {
        val result = suspendCancellableCoroutine { continuation ->
            val callbackImpl = object : NetworkResult {
                override fun result(view: View) {
                    continuation.resume(view) {
                        it.printStackTrace()
                    }
                }
            }
            realPost(callbackImpl)
        }
        return result
    }
}