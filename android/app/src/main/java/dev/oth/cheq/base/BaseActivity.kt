package dev.oth.cheq.base

import android.graphics.Rect
import android.os.Bundle
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AppCompatActivity
import androidx.window.layout.WindowMetrics
import androidx.window.layout.WindowMetricsCalculator
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import dev.oth.cheq.BuildConfig
import dev.oth.cheq.responses.ResponseClass
import dev.oth.cheq.utils.DLog
import dev.oth.cheq.utils.Preference
import com.google.gson.Gson

open class BaseActivity : AppCompatActivity() {

    private lateinit var windowMetrics : WindowMetrics
    private lateinit var currentBounds: Rect
    var screenWidth = 0
    var screenHeight = 0

    protected val pushPermissionRequestCode = 2000
    protected val bluetoothPermissionRequestCode = 2001
    val micPermissionRequestCode = 2004
    val defPermissionRequestCode = 2005

    var requestQueue: RequestQueue? = null

    private fun baseUserAgent() : String {
        return "##DrsApp/${BuildConfig.VERSION_NAME} ##DrsUUID/${getPreference().getUUID()}"
    }

    open fun getUserAgent(agentVal: String): String? {
        return "$agentVal ${baseUserAgent()}"
    }

    fun getPreference() : Preference = Preference.shared(this)


    override fun onCreate(savedInstanceState: Bundle?) {

        if (requestQueue == null) {
            requestQueue = Volley.newRequestQueue(applicationContext)
        }

        super.onCreate(savedInstanceState)

        backPressCatch()

        windowMetrics = WindowMetricsCalculator.getOrCreate().computeCurrentWindowMetrics(this)
        currentBounds = windowMetrics.bounds
        screenWidth = currentBounds.width()
        screenHeight = currentBounds.height()
    }

    private fun backPressCatch() {
        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                overrideBackPress()
            }
        })
    }

    open fun overrideBackPress() {
        finish()
    }

    open fun <T> requestBody(
        method: Int,
        url: String,
        listener: ResponseClass<T>,
        param: String,
        passingCodes: Set<String> = HashSet()
    ) {
//        DLog.w("request : ****\n${DEFINE.get() + url} \nparam :: $param\n********************")
        val request: StringRequest =
            object : StringRequest(method, DEFINE.getCheqUrl(),
                Response.Listener StringRequest@{ response ->
                    DLog.w("param : $param")
                    DLog.w("response : $response")
                    val result = Gson().fromJson(response, dev.oth.cheq.responses.BaseResponseModel::class.java)
                    DLog.w("result.header :: ${result.header}")
                },
                Response.ErrorListener { error ->
                    DLog.e(error.localizedMessage)
                }
            ) {
                override fun getBody(): ByteArray {
                    return param.toByteArray()
                }

                override fun getBodyContentType(): String {
                    return "application/json; charset=utf-8"
                }
            }
        request.setShouldCache(false)
        requestQueue?.add(request)
    }
}