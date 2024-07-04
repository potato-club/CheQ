package dev.oth.cheq.wutils

import android.Manifest
import android.content.Intent
import android.net.Uri
import android.os.Message
import android.webkit.JsPromptResult
import android.webkit.JsResult
import android.webkit.PermissionRequest
import android.webkit.ValueCallback
import android.webkit.WebChromeClient
import android.webkit.WebView
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import dev.oth.cheq.activities.MainActivity
import dev.oth.cheq.utils.DLog

class CheqChromeClient(val activity: MainActivity) : WebChromeClient() {

    override fun onCreateWindow(
        view: WebView?,
        isDialog: Boolean,
        isUserGesture: Boolean,
        resultMsg: Message?
    ): Boolean {
        return super.onCreateWindow(view, isDialog, isUserGesture, resultMsg)
    }

    override fun onCloseWindow(window: WebView?) {
        super.onCloseWindow(window)
    }

    override fun onJsAlert(
        view: WebView?,
        url: String?,
        message: String?,
        result: JsResult?
    ): Boolean {
        DLog.w()
        AlertDialog.Builder(activity).run {
            setMessage(message)
            setPositiveButton("확인"
            ) { dialog, which ->
                result?.confirm()
                dialog.dismiss()
            }
            setCancelable(true)
            setOnCancelListener {
                result?.cancel()
                it.dismiss()
            }
        }.create().show()
        return true
    }

    override fun onJsConfirm(
        view: WebView?,
        url: String?,
        message: String?,
        result: JsResult?
    ): Boolean {
        DLog.w("onJsConfirm")
        AlertDialog.Builder(activity).run {
            setMessage(message)
            setPositiveButton("확인"
            ) { dialog, which ->
                dialog.dismiss()
                result?.confirm()
            }
            setNegativeButton("취소") { dialog, which ->
                dialog.dismiss()
                result?.cancel()
            }

            setCancelable(true)
            setOnCancelListener {
                result?.cancel()
            }

        }.create().show()
        return true
//        return super.onJsConfirm(view, url, message, result)
    }

    override fun onJsPrompt(
        view: WebView?,
        url: String?,
        message: String?,
        defaultValue: String?,
        result: JsPromptResult?
    ): Boolean {
        DLog.w("onJsPrompt")
        AlertDialog.Builder(activity).run {
            setMessage(message)
            setPositiveButton("확인"
            ) { dialog, which ->
                dialog.dismiss()
                result?.confirm()
            }
            setNegativeButton("취소") { dialog, which ->
                dialog.dismiss()
                result?.cancel()
            }

            setCancelable(true)
            setOnCancelListener {
                result?.cancel()
            }
        }.create().show()
        return true
    }


    override fun onPermissionRequest(request: PermissionRequest?) {
//        request?.grant(request.resources)

        //will deprecated
        activity.permissionCodeCompletionMap[activity.micPermissionRequestCode] = micPermission@{
            if (it.grant) {
                request?.grant(request.resources);
            }
            else {
                super.onPermissionRequestCanceled(request)
            }
        }
        activity.runOnUiThread {
            activity.requestPermission(activity.micPermissionRequestCode, arrayListOf(Manifest.permission.RECORD_AUDIO, Manifest.permission.MODIFY_AUDIO_SETTINGS))
        }
    }

    private var filePathCallback: ValueCallback<Array<Uri>>? = null
    override fun onShowFileChooser(
        webView: WebView?,
        filePathCallback: ValueCallback<Array<Uri>>?,
        fileChooserParams: FileChooserParams?
    ): Boolean {
        this.filePathCallback = filePathCallback
        fileChooserIntentResult.launch(makeIntent(fileChooserParams))
        return true
    }

    private val fileChooserIntentResult = activity.registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
        filePathCallback?.onReceiveValue(FileChooserParams.parseResult(it.resultCode, it.data))
        filePathCallback = null
    }

    private fun makeIntent(fileChooserParams: FileChooserParams?) : Intent {
        val intent = Intent(Intent.ACTION_GET_CONTENT)
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        if (fileChooserParams?.mode == FileChooserParams.MODE_OPEN_MULTIPLE) {
            intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
        }
        intent.putExtra("return-data", true)
        intent.type = "*/*"

        return intent
    }

}