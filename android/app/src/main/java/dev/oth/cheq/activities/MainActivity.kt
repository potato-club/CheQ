package dev.oth.cheq.activities

import android.Manifest
import android.annotation.SuppressLint
import android.app.DownloadManager
import android.app.PendingIntent
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.ClipData
import android.content.ClipboardManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.graphics.Color
import android.net.Uri
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.NfcF
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.IBinder
import android.provider.Settings
import android.view.View
import android.view.WindowManager
import android.webkit.CookieManager
import android.webkit.ValueCallback
import android.webkit.WebSettings
import android.webkit.WebView.setWebContentsDebuggingEnabled
import android.widget.EditText
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat
import androidx.core.view.WindowInsetsControllerCompat
import com.google.android.material.snackbar.Snackbar
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import dev.oth.cheq.BuildConfig
import dev.oth.cheq.CommonSnackBar
import dev.oth.cheq.base.BaseActivity
import dev.oth.cheq.base.DEFINE
import dev.oth.cheq.databinding.ActivityMainBinding
import dev.oth.cheq.domains.BaseResultDomain
import dev.oth.cheq.domains.DMDataMapResult
import dev.oth.cheq.domains.DMDataResult
import dev.oth.cheq.domains.DMSetBgColor
import dev.oth.cheq.domains.DMTypeListModel
import dev.oth.cheq.domains.DMTypeModel
import dev.oth.cheq.domains.DMUrl
import dev.oth.cheq.domains.OnOffTypes
import dev.oth.cheq.domains.PermissionCheckModel
import dev.oth.cheq.domains.PermissionTypes
import dev.oth.cheq.domains.UploadTypes
import dev.oth.cheq.services.NotiService
import dev.oth.cheq.utils.DLog
import dev.oth.cheq.utils.Preference
import dev.oth.cheq.wutils.CheqChromeClient
import dev.oth.cheq.wutils.CheqJsInterf
import dev.oth.cheq.wutils.CheqWebViewClient
import dev.oth.cheq.wutils.WebviewUtils
import java.io.File
import java.math.BigInteger
import java.net.URLDecoder


/**
 * @Creator: isaacJang-dev
 * @Date: 2023-01-19
 */
class MainActivity : BaseActivity() {

    lateinit var binding: ActivityMainBinding

    private lateinit var cheqInterface: CheqJsInterf
    private lateinit var cheqWebViewClient: CheqWebViewClient
    private lateinit var cheqChromeClient: CheqChromeClient

    private var nfcAdapter: NfcAdapter? = null

    private val gson = GsonBuilder().serializeNulls().create()
    var myService: NotiService? = null
    var isService = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)

        DLog.e()

        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
        performTagOperations(intent)
        // 알림 권한 요청
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
//            askNotificationPermission()
//        } else {
//            initFcm()
//        }

        // 기본 url 로드
//        val url = DEFINE.getCheqUrl()


        //js interface, webview client, chrome client 초기화
        initDrsInterface()
        initDrsWebViewClient()
        initDrsChromeClient()



        // refresh layout init
        initRefreshLayout()

        setContentView(binding.root)
    }

    override fun onResume() {
        super.onResume()

        if (nfcAdapter == null) {
            Snackbar.make(binding.root, "NFC가 사용 불가능한 기종입니다.", Snackbar.LENGTH_LONG).show()
            return
        }

        val intent = Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE)

//        val filters = arrayOf<IntentFilter>()
//        nfcAdapter?.enableForegroundDispatch(this, pendingIntent, filters, null)

        val filters = arrayOf(
            IntentFilter(NfcAdapter.ACTION_TECH_DISCOVERED),
            IntentFilter(NfcAdapter.ACTION_TAG_DISCOVERED),
            IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED),
        )
        val techList = arrayOf(
            arrayOf(
                NfcF::class.java.name
            )
        )
        nfcAdapter?.enableForegroundDispatch(this, pendingIntent, filters, techList)


        //webview 초기화
        val txtEdit = EditText(this)


        val clsBuilder = AlertDialog.Builder(this)
        if (!getPreference().isNull(Preference.KEY_URL)) {
            txtEdit.hint = "http://192.168.0.1:3000"
            txtEdit.setText(getPreference().getString(Preference.KEY_URL))
        }
        clsBuilder.setTitle("서버 URL")
        clsBuilder.setView(txtEdit)
        clsBuilder.setPositiveButton(
            "확인"
        ) { dialog, which ->
            val strText = txtEdit.text.toString()
            dialog.dismiss()
            getPreference().put(Preference.KEY_URL, strText)
            initWebView(strText)
        }
        clsBuilder.setNegativeButton(
            "취소"
        ) { dialog, which ->
            dialog.dismiss()
        }
        clsBuilder.show()
//        initWebView(url)
    }


    override fun onPause() {
        super.onPause()
        nfcAdapter?.disableForegroundDispatch(this)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
//        DLog.w("onNewIntent=${intent.action}")
//        DLog.w("onNewIntent=${intent.extras}")
        performTagOperations(intent)
    }

    private fun performTagOperations(intent: Intent) {
        DLog.w("performTagOperations")
        val action = intent.action
        if (action == NfcAdapter.ACTION_TAG_DISCOVERED || action == NfcAdapter.ACTION_TECH_DISCOVERED) {
            DLog.w("discovered=$action")
            DLog.w("${intent.extras}")
            //PERFORM TAG OPERATIONS
            val tag : Tag? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.getParcelableExtra(NfcAdapter.EXTRA_TAG, Tag::class.java)
            } else {
                intent.getParcelableExtra(NfcAdapter.EXTRA_TAG)
            }
            DLog.w("tag : $tag")
            tag?.let {
                val uid = bin2hex(it.id)
                runBridgeCode(
                    "scanNFCResult",
                    DMDataResult(
                        BaseResultDomain("success", true), uid
                    )
                )
            }
            return
        }
        try {
            Snackbar.make(binding.root, "잘못된 TAG 입니다.", Snackbar.LENGTH_LONG).show()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    //To display the UID
    private fun bin2hex(data: ByteArray): String {
        return String.format("%0" + (data.size * 2) + "X", BigInteger(1, data))
    }

    // 알림 권한 요청
    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    private fun askNotificationPermission(completion: (Boolean) -> Unit) {
        permissionCodeCompletionMap[pushPermissionRequestCode] = push@{
            completion.invoke(it.grant)
//            if (it.grant) {
//                initFcm()
//            }
        }
        requestPermission(
            pushPermissionRequestCode,
            arrayListOf(
                Manifest.permission.POST_NOTIFICATIONS,
                Manifest.permission.FOREGROUND_SERVICE,
                Manifest.permission.FOREGROUND_SERVICE_LOCATION,
            )
        )
    }
    // bluetooth
    private fun askBlueToothPermission(type: String) {
        DLog.w()
        permissionCodeCompletionMap[bluetoothPermissionRequestCode] = result@{
            DLog.w("${it.grant}")
            if (it.grant) {
                val bluetoothManager = getSystemService(BLUETOOTH_SERVICE) as BluetoothManager
                val btAdapter = bluetoothManager.adapter

                runOnUiThread ui@{
                    if (btAdapter == null || !btAdapter.isEnabled) {
                        DLog.w()
                        Snackbar.make(binding.root, "블루투스 기능을 확인해주세요", Snackbar.LENGTH_LONG).show()
                        val bleIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                        startActivity(bleIntent)
                        return@ui
                    }
                    DLog.w()
                    beaconSwitch(type)
                }
                return@result
            }

            permissionDenied("beaconControlResult", PermissionTypes.bluetooth.getName())
        }

        requestPermission(
            bluetoothPermissionRequestCode,
            arrayListOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.BLUETOOTH_ADMIN,
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_ADVERTISE,
                Manifest.permission.BLUETOOTH_CONNECT)
        )
    }

    //fcm 초기화
    private fun initFcm() {
//        FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
//            if (!task.isSuccessful) {
//                DLog.w(msg = "Fetching FCM registration token failed", tr = task.exception)
//                return@OnCompleteListener
//            }
//
//            // Get new FCM registration token
//            val token = task.result
//
//            // Preference 저장소에 push token 저장
//            getPreference().put(Preference.KEY_FCM_TOKEN, token)
//        })
    }

    // js interface (bridge) 초기화
    /**
     * 공통사항
     *  - try 문 안에서 exception 발생시 parsing error 리턴
     * */
    private fun initDrsInterface() {
        cheqInterface = CheqJsInterf().apply {
            /** 백그라운드 색상 지정 */
            setBackgroundColor = {
                try {
                    val domain = gson.fromJson(it, DMSetBgColor::class.java)

                    runOnUiThread {
                        setBackgroundColor(domain.color, domain.light)
                    }
                } catch (e: Exception) {
                    DLog.printException(e)
                    runBridgeCode(
                        "setBackgroundColorResult",
                        BaseResultDomain(
                            "setBackgroundColor paring error",
                            false
                        )
                    )
                }
            }

            /** 상단 색상 지정 */
            setTopAreaColor = {
                try {
                    val domain = gson.fromJson(it, DMSetBgColor::class.java)

                    runOnUiThread {
                        setTopAreaColor(domain.color, domain.light)
                    }
                } catch (e: Exception) {
                    DLog.printException(e)
                    runBridgeCode(
                        "setTopAreaColorResult",
                        BaseResultDomain(
                            "setTopAreaColor paring error",
                            false
                        )
                    )
                }
            }

            /** 하단 색상 지정 */
            setBottomAreaColor = {
                try {
                    val domain = gson.fromJson(it, DMSetBgColor::class.java)

                    runOnUiThread {
                        setBottomAreaColor(domain.color, domain.light)
                    }
                } catch (e: Exception) {
                    DLog.printException(e)
                    runBridgeCode(
                        "setBottomAreaColorResult",
                        BaseResultDomain(
                            "setBottomAreaColor paring error",
                            false
                        )
                    )
                }
            }


            /**
             * 로컬 데이터 업로드
             * types
             * - fcmToken
             * - deviceName
             * - osVersion
             * - resolution
             * */
            uploadData = uploadData@{
                try {
                    // Single type 파싱에 성공하면, single type 리턴
                    val domainSingle = gson.fromJson(it, DMTypeModel::class.java)
                    uploadData(type = domainSingle.type)
                    return@uploadData
                } catch (ignored: Exception) {
                }
                try {
                    // single type 에서 실패 이후 진입
                    // list type 리턴
                    val domainList = gson.fromJson(it, DMTypeListModel::class.java)
                    uploadData(types = domainList.types)
                    return@uploadData
                } catch (e: Exception) {
                    DLog.printException(e)
                }

                //두 가지 모두 실패 시 파싱 오류 리턴
                runBridgeCode(
                    "uploadDataResult",
                    BaseResultDomain("uploadData parsing Error", false)
                )
            }

            refreshAble = refreshAble@{
                try {
                    val domain = gson.fromJson(it, DMTypeModel::class.java)
                    runOnUiThread {
                        refreshLayoutActivate(domain.type)
                    }
                } catch (e: Exception) {
                    DLog.printException(e)
                    runBridgeCode(
                        "refreshAbleResult",
                        BaseResultDomain("refreshAble parsing Error", false)
                    )
                }
            }

            openBrowser = openBrowser@{
                try {
                    val domain = gson.fromJson(it, DMUrl::class.java)
                    runOnUiThread {
                        this@MainActivity.openBrowser(domain.url) {
                            runBridgeCode("openBrowserResult",
                                BaseResultDomain("success", true)
                            )
                        }
                    }
                } catch (e: Exception) {
                    DLog.printException(e)
                    runBridgeCode(
                        "openBrowserResult",
                        BaseResultDomain(
                            "open Browser url parsing Error",
                            false
                        )
                    )
                }
            }

            beaconControl = beaconControl@{//todo
                DLog.w()
                try {
                    val domain = gson.fromJson(it, DMTypeModel::class.java)
                    runOnUiThread {
                        askNotificationPermission { pushNotiResult ->
                            if (pushNotiResult) {
                                askBlueToothPermission(domain.type)
                            }
                        }

                    }
                } catch (e: Exception) {
                    DLog.printException(e)
                    runBridgeCode(
                        "beaconControlResult",
                        BaseResultDomain("beaconControl parsing Error", false)
                    )
                }
            }

            scanNFC = scanNFC@{
                DLog.w("scanNFC($it)")
                nfcScan()
            }

            // develop test 기능
            devTest = devTest@{
                if (!BuildConfig.DEBUG) {
                    return@devTest
                }


            }
        }
    }

    private fun startService(completion: (Boolean) -> Unit) {
        DLog.w("isService : $isService")
        if (isService) {
            completion.invoke(false)
            return
        }
        val intent = Intent(this@MainActivity, NotiService::class.java)
        bindService(intent, conn, Context.BIND_AUTO_CREATE)
        completion.invoke(true)
    }

    private fun turnOffService() {
        try {
            myService?.stopScan()
            myService?.onDestroy()
            unbindService(conn)
            isService = false
        } catch (e: Exception) {
            e.printStackTrace()
        }
        myService = null
    }

    private val conn = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            val mb = service as NotiService.LocalBinder
            myService = mb.service
            isService = true
            val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager

            mb.service.startScan(bluetoothManager.adapter)
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            isService = false
            myService = null
        }

    }

    // webview client initialize
    private fun initDrsWebViewClient() {
        cheqWebViewClient = CheqWebViewClient(this)

        cheqWebViewClient.run {
            onPageFinishedOverride = { view, url ->
                binding.refreshLayout.isRefreshing = false

//                DLog.w("run refresh code")
//                runJsCode(DEFINE.REFRESH_BY_DIALOG_JS_CODE) {
//                    DLog.w("REFRESH_BY_DIALOG_JS_CODE :: $it")
//                }
            }
        }
    }

    // chrome client initialize
    private fun initDrsChromeClient() {
        cheqChromeClient = CheqChromeClient(this)

    }

    // webview initialize
    @SuppressLint("SetJavaScriptEnabled")
    private fun initWebView(startURL: String) {
        val settings = binding.webView.settings

        settings.run {
            cacheMode = WebSettings.LOAD_DEFAULT

            javaScriptEnabled = true
            javaScriptCanOpenWindowsAutomatically = true

            setSupportZoom(true)
            builtInZoomControls = true
            displayZoomControls = true

            setSupportMultipleWindows(true)

            mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW

            displayZoomControls = false
            domStorageEnabled = true
        }

        binding.webView.run {
            isHorizontalScrollBarEnabled = false
            isVerticalScrollBarEnabled = true

            setLayerType(View.LAYER_TYPE_HARDWARE, null)

            // bridge 설정
            addJavascriptInterface(cheqInterface, "cheq")

            webViewClient = cheqWebViewClient
            webChromeClient = cheqChromeClient

            // 운영 서버가 아닐 경우 debug ( inspect ) - able 설정
            setWebContentsDebuggingEnabled(true)

            DLog.w("startUrl : $startURL")
            // user agent override
            binding.webView.settings.userAgentString =
                getUserAgent(binding.webView.settings.userAgentString)
            binding.webView.settings.mediaPlaybackRequiresUserGesture = false

            // cookie 초기화 후 로딩
            CookieManager.getInstance().removeSessionCookies {
                loadUrl(startURL)
            }



            setDownloadListener { url, _, contentDisposition, mimetype, _ ->
                val encodedContentDis = URLDecoder.decode(contentDisposition, "UTF-8")
                val fileName = WebviewUtils().getFileNameFromContentDisposition(encodedContentDis)
                if (fileName.isEmpty()) {
                    CommonSnackBar(
                        this@MainActivity,
                        binding.root,
                        Snackbar.LENGTH_SHORT,
                        "파일명을 가져오다가 오류가 발생했습니다."
                    ).show()
                    return@setDownloadListener
                }
                downloadFile(url, fileName, mimetype)
            }
        }

    }


    // sdk 29 이상 호출 함수
    private fun downloadFile(url: String, fileName: String, mimetype: String) {
        val cookie = CookieManager.getInstance().getCookie(url)

        val request = DownloadManager.Request(Uri.parse(url))
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, fileName)
        request.addRequestHeader("Cookie", cookie)
        request.setMimeType(mimetype)
        request.addRequestHeader(
            "User-Agent",
            getUserAgent(binding.webView.settings.userAgentString)
        )
        request.setDescription("Downloading File")
        request.setAllowedOverMetered(true)
        request.setAllowedOverRoaming(true)
        request.setTitle(fileName)
        request.setRequiresCharging(false)
        request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE)

        val startSnackBar =
            CommonSnackBar(
                this,
                binding.root,
                Snackbar.LENGTH_SHORT,
                "상태바에서 다운로드가 진행됩니다."
            ).show()

        // Start the download.
        val downloadManager = getSystemService(DOWNLOAD_SERVICE) as DownloadManager
        val downloadId = downloadManager.enqueue(request)

        // 다운로드 완료 시 호출
        val onDownloadComplete = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val id = intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1)
                if (downloadId != id) {
                    return
                }
                val query: DownloadManager.Query = DownloadManager.Query()
                query.setFilterById(id)
                val cursor = downloadManager.query(query)
                if (!cursor.moveToFirst()) {
                    return
                }

                runOnUiThread {
                    if (startSnackBar.isShowing()) {
                        startSnackBar.dismiss()
                    }
                    val columnIndex = cursor.getColumnIndex(DownloadManager.COLUMN_STATUS)
                    when (cursor.getInt(columnIndex)) {
                        DownloadManager.STATUS_SUCCESSFUL -> {
                            DLog.w("download success")
                            val scSnackbar = CommonSnackBar(
                                this@MainActivity,
                                binding.root,
                                Snackbar.LENGTH_LONG,
                                "다운로드를 완료하였습니다."
                            )
                            scSnackbar.setOnClickNegative("닫기") {
                                scSnackbar.dismiss()
                            }
                            scSnackbar.setOnClickPositive("파일 열기") {
                                scSnackbar.dismiss()
                                startActivity(Intent(DownloadManager.ACTION_VIEW_DOWNLOADS));
                            }

                            val cIndex = cursor.getColumnIndex(DownloadManager.COLUMN_LOCAL_URI)
                            if (cIndex > 0) {
                                val fileUri: String = cursor.getString(cIndex)
                                val mFile = Uri.parse(fileUri).path?.let { File(it) }
                                val absolutePath = mFile?.absolutePath

                                if (absolutePath != null) {
                                    scSnackbar.show()
                                    return@runOnUiThread
                                }
                            }
                            CommonSnackBar(
                                this@MainActivity,
                                binding.root,
                                Snackbar.LENGTH_LONG,
                                "다운로드가 완료되었습니다."
                            ).show()
                        }

                        DownloadManager.STATUS_PAUSED -> {
                            DLog.w("download pause")
                            CommonSnackBar(
                                this@MainActivity,
                                binding.root,
                                Snackbar.LENGTH_LONG,
                                "다운로드가 중단되었습니다."
                            ).show()
                        }

                        DownloadManager.STATUS_FAILED -> {
                            DLog.w("download failed")
                            CommonSnackBar(
                                this@MainActivity,
                                binding.root,
                                Snackbar.LENGTH_LONG,
                                "다운로드가 취소되었습니다."
                            ).show()
                        }
                    }
                }
            }
        }

        val intentFilter = IntentFilter()
        intentFilter.addAction(DownloadManager.ACTION_DOWNLOAD_COMPLETE)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            registerReceiver(onDownloadComplete, intentFilter, RECEIVER_EXPORTED)
        } else {
            registerReceiver(onDownloadComplete, intentFilter)
        }
    }

    // refresh init
    private fun initRefreshLayout() {
        binding.refreshLayout.setOnRefreshListener {
            binding.refreshLayout.isRefreshing = true
            binding.webView.reload()
        }
    }


    // background color set
    private fun setBackgroundColor(inputColor: String, isLight: Boolean) {
        DLog.w("color: $inputColor, isLight : $isLight")
        var color = inputColor
        if (!color.contains("#")) {
            color = "#$color"
        }
        setTopAreaColor(color, isLight, true)
        setBottomAreaColor(color, isLight, true)
        runBridgeCode("setBackgroundColorResult",
            BaseResultDomain("success", true)
        )
    }

    private fun setTopAreaColor(inputColor: String, isLight: Boolean, isFromBack: Boolean = false) {
        var color = inputColor.replace("#", "")
        color = "#$color"

        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
        window.statusBarColor = Color.parseColor(color)

        WindowInsetsControllerCompat(window, window.decorView).isAppearanceLightStatusBars = isLight
        if (!isFromBack) {
            runBridgeCode("setTopAreaColorResult",
                BaseResultDomain("success", true)
            )
        }
    }

    //only work in gesture mode
    private fun setBottomAreaColor(
        inputColor: String,
        isLight: Boolean,
        isFromBack: Boolean = false
    ) {
        var color = inputColor.replace("#", "")
        color = "#$color"

        window.navigationBarColor = Color.parseColor(color)
        WindowInsetsControllerCompat(window, window.decorView).isAppearanceLightNavigationBars =
            isLight
        if (!isFromBack) {
            runBridgeCode("setBottomAreaColorResult",
                BaseResultDomain("success", true)
            )
        }
    }


    //권한 거절 시 호출
    fun permissionDenied(resultMethodName: String?, type: String) {
        val typeText = when (type.lowercase()) {
            PermissionTypes.camera.getName() -> "카메라"
            PermissionTypes.microphone.getName() -> "마이크"
            PermissionTypes.external.getName() -> "저장소"
            PermissionTypes.bluetooth.getName() -> "블루투스"
            else -> ""
        }

        val alertText =
            "개인 정보 설정으로 인해 ${typeText}에 액세스할 수 없는 것 같습니다. 다음을 수행하여 이 문제를 해결할 수 있습니다.\n\n1. 아래의 설정 버튼을 눌러 설정 앱을 엽니다.\n\n2. $typeText 권한을 켭니다.\n\n3. 이 앱을 열고 다시 시도하십시오."

        val dialogBuilder = AlertDialog.Builder(this).run {
            setTitle("오류")
            setMessage(alertText)
            setCancelable(false)
            setPositiveButton("설정") { dialog, which ->
                dialog.dismiss()
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                intent.data = Uri.parse("package:$packageName")
                startActivity(intent)
            }
            setNegativeButton("취소") { dialog, witch ->
                dialog.dismiss()
            }
        }
        runOnUiThread {
            val dialog = dialogBuilder.create()
            dialog.show()
        }
        if (resultMethodName != null) {
            runBridgeCode(resultMethodName,
                BaseResultDomain("permission denied", false)
            )
        }
    }

    //단일 data upload시 호출
    private fun uploadData(type: String) {
        val resultModel = getDataForUpload(type)
        runBridgeCode("uploadDataResult", resultModel)
    }

    // 리스트 data upload시 호출
    private fun uploadData(types: List<String>) {
        val resultMap = hashMapOf<String, String>()

        for (key in types) {
            val result = getDataForUpload(key)
            if (result.result.isResultBoolean) {
                resultMap[key] = result.data as String
            } else {
                resultMap[key] = "null"
            }
        }

        val resultModel = DMDataMapResult(
            BaseResultDomain(
                "success",
                true
            ), resultMap
        )

        val result: String = gson.toJson(resultModel)
        runBridgeCode("uploadDataResult", result)
    }

    //실제 데이터 return 함수
    private fun getDataForUpload(type: String): DMDataResult {
        return when (type.lowercase()) {
            UploadTypes.fcmToken.getName() -> {
                if (getPreference().isNull(Preference.KEY_FCM_TOKEN)) {
                    return DMDataResult(
                        BaseResultDomain(
                            "failed : null",
                            false
                        ), null
                    )
                }

                val token = getPreference().getString(Preference.KEY_FCM_TOKEN)!!

                DMDataResult(
                    BaseResultDomain(
                        "success",
                        true
                    ), token
                )
            }

            UploadTypes.deviceId.getName() -> {
                DMDataResult(
                    BaseResultDomain(
                        "success",
                        true
                    ), Build.MODEL
                )
            }

            else -> {
                DMDataResult(
                    BaseResultDomain(
                        "unknown key",
                        false
                    ), null
                )
            }
        }
    }

    //clipboard 저장 기능
    private fun copyToClipBoard(copyData: String) {
        try {
            val clipboard: ClipboardManager =
                getSystemService(CLIPBOARD_SERVICE) as ClipboardManager
            val clip = ClipData.newPlainText("cheq", copyData)
            clipboard.setPrimaryClip(clip)
            runBridgeCode("copyToClipBoardResult",
                BaseResultDomain("success", true)
            )
        } catch (e: Exception) {
            DLog.printException(e)
            runBridgeCode(
                "copyToClipBoardResult",
                BaseResultDomain("failed : ${e.localizedMessage}", false)
            )
        }
    }


    //refreshLayout enable, disable
    private fun refreshLayoutActivate(type: String) {
        binding.refreshLayout.isEnabled = OnOffTypes.ON.name.lowercase() == type.lowercase()
        runBridgeCode("refreshAbleResult", BaseResultDomain("success", true))
    }

    //open Browser
    private fun openBrowser(originUrl: String, completion: () -> Unit) {
        var url = originUrl
        if (!url.startsWith("http://") && !url.startsWith("https://")) {
            url = "http://$url"
        }
        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        startActivity(browserIntent)
        completion.invoke()
    }

    private fun nfcScan() {
        if (nfcAdapter?.isEnabled == false) {
            val dialogBuilder = AlertDialog.Builder(this).run {
                setTitle("can not access nfc")
                setMessage("nfc가 꺼져있는 것 같습니다.")
                setCancelable(false)
                setPositiveButton("설정") { dialog, which ->
                    dialog.dismiss()
                    openNfcSettings()
                }
                setNegativeButton("취소") { dialog, witch ->
                    dialog.dismiss()
                }
            }
            runOnUiThread {
                val dialog = dialogBuilder.create()
                dialog.show()
            }
            runBridgeCode("nfcScanResult", BaseResultDomain("adapter unable", false))
            return
        }
        DLog.w("ready To Scan")
    }

    private fun openNfcSettings() {
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Intent(Settings.Panel.ACTION_NFC)
        } else {
            Intent(Settings.ACTION_WIRELESS_SETTINGS)
        }
        startActivity(intent)
    }

    //refreshLayout enable, disable
    private fun beaconSwitch(type: String) {

        val switch = OnOffTypes.ON.name.lowercase() == type.lowercase()
        DLog.w(switch.toString())
        if (switch) {
            startService {
                runBridgeCode("beaconControlResult", BaseResultDomain(if (it){"success : turn on"}else{"failed : service start failed"}, it))
            }
            return
        }

        turnOffService()
        runBridgeCode("beaconControlResult", BaseResultDomain("success : turn off", true))
    }

    // endregion

    //permission request 함수 closure 로 작업
    var permissionCodeCompletionMap = hashMapOf<Int, ((PermissionCheckModel) -> Unit)>()

    //request permission
    fun requestPermission(permissionCode: Int, permissions: ArrayList<String>) {
        val isntGrantedPermissions = arrayListOf<String>()
        for (permission in permissions) {
            if (ContextCompat.checkSelfPermission(
                    this,
                    permission
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                isntGrantedPermissions.add(permission)
            }
        }
        if (isntGrantedPermissions.size == 0) {
            permissionCodeCompletionMap[permissionCode]?.invoke(PermissionCheckModel(true))
            return
        }
        val array = arrayOfNulls<String>(isntGrantedPermissions.size)
        requestPermissions(isntGrantedPermissions.toArray(array), permissionCode)
    }

    //request permission result
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        var grant = true
        var rationale = true
        for (permission in permissions) {
            if (!shouldShowRequestPermissionRationale(permission)) {
                rationale = false
                break
            }
        }
        for (result in grantResults) {
            if (result != PackageManager.PERMISSION_GRANTED) {
                grant = false
                break
            }
        }
        runOnUiThread {
            permissionCodeCompletionMap[requestCode]?.invoke(PermissionCheckModel(grant, rationale))
        }
    }


    //run javascript Code
    private fun runBridgeCode(
        function: String,
        jsonType: Any,
        valueCallback: ValueCallback<String>? = null
    ) {
        runOnUiThread {
            val resultString = Gson().toJson(jsonType)
            printConsole("$function[$resultString]")
            DLog.w("$function[$resultString]")
            binding.webView.evaluateJavascript(
                "window.${DEFINE.VUE_BRIDGE}.$function(${resultString})",
                valueCallback
            );
        }
    }

    private fun runJsCode(jsCode: String, valueCallback: ValueCallback<String>? = null) {
        runOnUiThread {
            binding.webView.evaluateJavascript(jsCode, valueCallback);
        }
    }

    private fun printConsole(msg: String) {
        if (BuildConfig.DEBUG) {
            runOnUiThread {
                binding.webView.evaluateJavascript("console.log(`$msg`)", null);
            }
        }
    }

    private lateinit var finishSnackBar: CommonSnackBar

    //back 버튼 클릭 시 호출
    override fun overrideBackPress() {
        showCloseSnack()
    }

    // 뒤로가기 한번더 누르면 꺼지도록 동작하는 snack bar
    private fun showCloseSnack() {
        if (!this::finishSnackBar.isInitialized) {
            finishSnackBar = CommonSnackBar(this, binding.root)
        }

        if (finishSnackBar.isShowing()) {
            super.overrideBackPress()
            return
        }

        finishSnackBar = CommonSnackBar(this, binding.root)
        finishSnackBar.setDuration(3000)
        finishSnackBar.setMessage("뒤로가기를 한번 더 누르시면 종료됩니다.")
        finishSnackBar.setOnClickPositive("취소") {
            it.dismiss()
        }

        finishSnackBar.show()
    }
//
//    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
//    inline fun <reified T : Parcelable> Intent.parcelable(key: String): T? = when {
//        Build.VERSION.SDK_INT >= 33 -> getParcelableExtra(key, T::class.java)
//        else -> @Suppress("DEPRECATION") getParcelableExtra(key) as? T
//    }
//
//    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
//    inline fun <reified T : Parcelable> Bundle.parcelable(key: String): T? = when {
//        Build.VERSION.SDK_INT >= 33 -> getParcelable(key, T::class.java)
//        else -> @Suppress("DEPRECATION") getParcelable(key) as? T
//    }

    override fun onDestroy() {
        if (isService) {
            turnOffService()
        }
        super.onDestroy()
    }

}