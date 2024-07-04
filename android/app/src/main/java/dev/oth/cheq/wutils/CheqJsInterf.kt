package dev.oth.cheq.wutils

import android.webkit.JavascriptInterface

class CheqJsInterf(

) {

    lateinit var setBackgroundColor : ((String)->Unit)
    @JavascriptInterface
    fun setBackgroundColor(json: String) { setBackgroundColor.invoke(json) }

    lateinit var setTopAreaColor : ((String)->Unit)
    @JavascriptInterface
    fun setTopAreaColor(json: String) { setTopAreaColor.invoke(json) }

    lateinit var setBottomAreaColor : ((String)->Unit)
    @JavascriptInterface
    fun setBottomAreaColor(json: String) { setBottomAreaColor.invoke(json) }

    lateinit var uploadData : ((String)->Unit)
    @JavascriptInterface
    fun uploadData(json: String) { uploadData.invoke(json) }

    lateinit var refreshAble : ((String)->Unit)
    @JavascriptInterface
    fun refreshAble(json: String) { refreshAble.invoke(json) }

    lateinit var openBrowser : ((String)->Unit)
    @JavascriptInterface
    fun openBrowser(json: String) { openBrowser.invoke(json) }

    lateinit var devTest : ((String)->Unit)
    @JavascriptInterface
    fun devTest(json: String) { devTest.invoke(json) }

    lateinit var beaconControl : ((String)->Unit)
    @JavascriptInterface
    fun beaconControl(json: String) { beaconControl.invoke(json) }

    lateinit var scanNFC : ((String)->Unit)
    @JavascriptInterface
    fun scanNFC(json: String) { scanNFC.invoke(json) }
}