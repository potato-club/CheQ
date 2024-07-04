package dev.oth.cheq.wutils

import android.graphics.Bitmap
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import dev.oth.cheq.activities.MainActivity
import dev.oth.cheq.utils.DLog

class CheqWebViewClient(var activity: MainActivity) : WebViewClient() {

    override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
        super.onPageStarted(view, url, favicon)
    }

    var onPageFinishedOverride: ((view: WebView?, url: String?)->Unit)? = null

    override fun onPageFinished(view: WebView?, url: String?) {
        super.onPageFinished(view, url)

        DLog.w("onPageFinished :: $url")
        onPageFinishedOverride?.invoke(view, url)
    }

    override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
        return super.shouldOverrideUrlLoading(view, request)
    }
}