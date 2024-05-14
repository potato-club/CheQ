//
//  WebController.swift
//  dreams
//
//  Created by Admin on 2023/03/28.
//

import Foundation
import UIKit
import WebKit
import ActivityKit


import JDID


class WebController: JVC {

    let refreshControl : UIRefreshControl = {
        let v = UIRefreshControl()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tintColor = .black
        return v
    }()

    let webViewWrapScroll : UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.showsHorizontalScrollIndicator = false
        v.bounces = true
        v.alwaysBounceHorizontal = false
        v.alwaysBounceVertical = true
        v.isUserInteractionEnabled = true
        v.showsVerticalScrollIndicator = false
        return v
    }()

    lazy var curWebView : WKWebView = {
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.preferences.javaScriptCanOpenWindowsAutomatically = true
        webViewConfig.allowsInlineMediaPlayback = true

        let userContentController = WKUserContentController()

        for item in BridgeList.allCases {
            userContentController.add(self, name: item.rawValue)
        }

        webViewConfig.userContentController = userContentController
        
        let wkWebView = WKWebView(frame: .zero, configuration: webViewConfig)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.allowsBackForwardNavigationGestures = false
        wkWebView.scrollView.bounces = false
        wkWebView.scrollView.alwaysBounceHorizontal = false
        wkWebView.scrollView.alwaysBounceVertical = false
        //MARK: inspectable
        #if DEBUG
        webViewConfig.preferences.setValue(true, forKey: "developerExtrasEnabled")
        if #available(iOS 16.4, *) {
            wkWebView.isInspectable = true
        }
        #else
        webViewConfig.preferences.setValue(DEFINE.getDreamsUrl() != DEFINE.getDreamsUrl(serverType: .PRODUCT), forKey: "developerExtrasEnabled")
        if #available(iOS 16.4, *) {
            wkWebView.isInspectable = DEFINE.getDreamsUrl() != DEFINE.getDreamsUrl(serverType: .PRODUCT)
        }
        #endif

        if let userAgent = wkWebView.value(forKey: "userAgent") as? String {
            wkWebView.customUserAgent = "\(userAgent) \(baseUserAgent())"
        }

        return wkWebView
    }()

    let topAreaView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.isUserInteractionEnabled = false
        return v
    }()
    let bottomAreaView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.isUserInteractionEnabled = false
        return v
    }()
    
//    let progressView : UIProgressView = {
//        let v = UIProgressView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.progressViewStyle = .bar
//        return v
//    }()
    lazy var floatingBtn = FloatingBtn(jvc: self)

    var defUrl = "https://www.naver.com"
//    var defUrl = ""
    
    var swipeAble = true
    
    var observationMap : [String:NSKeyValueObservation?] = {
        var map : [String:NSKeyValueObservation?] = [:]
        for obKey in Observers.allCases {
            map[obKey.name] = nil
        }

        return map
    }()


    lazy var jdid = UdidLoader(Bundle.main.bundleIdentifier ?? "")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let juid = jdid.getDeviceID()
        print("jdid : \(juid)")

        view.backgroundColor = .white
        
        addAreaView()
        addWebView()
//        if DEFINE.URL_BASE != DEFINE.URL_ENT {
//            addProgressBar()
//        }
        addGesture()
        
        floatingBtn.addChild(item: FloatingBtn.FloatingChildModel(indexId: 1, iconName: "qr_code", clickEvent: {
            self.floatingBtn.floatingActive(setActive: false)
            DLog.p("onClick qr 1")
//            self.present(QRViewController(), animated: true)
//            if let navi = self.navigationController {
//                navi.pushViewController(QRViewController(), animated: true)
//            }
//            self.centralManager.scanForPeripherals(withServices: nil) // 스캔 시작
            self.startLocaion() //beacon
            self.startTimer()
        }))
        floatingBtn.addChild(item: FloatingBtn.FloatingChildModel(indexId: 2, iconName: "id_card", clickEvent: {
            self.floatingBtn.floatingActive(setActive: false)
            DLog.p("onClick Id Card 2")
//            self.present(IdCardViewController(), animated: true)
//            self.centralManager.stopScan()
        }))
        floatingBtn.build()
    }
    
    var timer : Timer? = nil
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(looperBody), userInfo: nil, repeats: true)
    }
    
    @objc func looperBody() {
        Task {
            let reqHelper = RequestConstant.shared
            let parameters = ""
            await reqHelper.request(headers: [:],
                                 url: "http://date.jsontest.com/",
                                 parameters: parameters,
                                 of: ResponseJSONTest.self)
            
            DLog.p("request done // \(lastBeacon)")
        }
    }
    
    func islandLanding() {
        if #available(iOS 16.2, *) {
//            if ActivityAuthorizationInfo().areActivitiesEnabled {
//                let future = Calendar.current.date(byAdding: .second, value: self.times.timer, to: Date())!
//                let date = Date.now...future
//                let initialContentState = IslandwidgetAttributes.ContentState(taskName: IslandwidgetAttributes.ContentState.connected, timer: date)
//                let activityAttributes = IslandwidgetAttributes.ContentState(isTimer: true)
//                let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
//
//                do {
//                    let activity = try Activity.request(attributes: activityAttributes, content: activityContent)
//                    print("Requested Lockscreen Live Activity(Timer) \(String(describing: activity.id)).")
//                } catch (let error) {
//                    print("Error requesting Lockscreen Live Activity(Timer) \(error.localizedDescription).")
//                }
//            }
        }
    }
    
    
    //MARK: - Draw View
    func addWebView() {
        webViewWrapScroll.delegate = self

        webViewWrapScroll.addSubview(refreshControl)
        webViewWrapScroll.addSubview(curWebView)

        view.addSubview(webViewWrapScroll)

        NSLayoutConstraint.activate([
            webViewWrapScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webViewWrapScroll.leftAnchor.constraint(equalTo: view.leftAnchor),
            webViewWrapScroll.rightAnchor.constraint(equalTo: view.rightAnchor),
            webViewWrapScroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            curWebView.topAnchor.constraint(equalTo: webViewWrapScroll.topAnchor),
            curWebView.leftAnchor.constraint(equalTo: webViewWrapScroll.leftAnchor),
            curWebView.rightAnchor.constraint(equalTo: webViewWrapScroll.rightAnchor),
            curWebView.bottomAnchor.constraint(equalTo: webViewWrapScroll.bottomAnchor),
            curWebView.widthAnchor.constraint(equalTo: webViewWrapScroll.widthAnchor, multiplier: 1),
            curWebView.heightAnchor.constraint(equalTo: webViewWrapScroll.heightAnchor, multiplier: 1),
        ])

        curWebView.uiDelegate = self
        curWebView.navigationDelegate = self

        webViewWrapScroll.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)

        //cookie 초기화
//        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler:{ })
//        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//
//        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
//            records.forEach { record in
//                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
//            }
//        }
        // session 초기화 ( 새로할당 )
//        let newProcessPool = WKProcessPool()
//        curWebView.configuration.processPool = newProcessPool
//
        guard let url = URL(string: defUrl) else {
            DLog.p("url is error")
            return
        }
        
        DispatchQueue.main.async {
            self.curWebView.load(URLRequest(url: url))
        }
    }

    @objc func reloadWebView(_ sender: UIRefreshControl) {
        curWebView.reload()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            sender.endRefreshing()
        }
    }
    

    func addAreaView() {
//        curWebView
        view.addSubview(topAreaView)
        view.addSubview(bottomAreaView)
        
        NSLayoutConstraint.activate([
            topAreaView.topAnchor.constraint(equalTo: view.topAnchor),
            topAreaView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topAreaView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topAreaView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            bottomAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomAreaView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomAreaView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        curWebView.uiDelegate = self
        curWebView.navigationDelegate = self
    }
    
    //MARK: - GESTURE
    private func addGesture() {
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeRightRecognizer.direction = .right
        curWebView.addGestureRecognizer(swipeRightRecognizer)
    }
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if !swipeAble {
            return
        }
        
        guard let url = curWebView.url?.absoluteString else {
            return
        }
        
//        if DEFINE.getDreamsUrl().replacingOccurrences(of: "/", with: "") == url.replacingOccurrences(of: "/", with: "") {
//            return
//        }
//        
//        runJsCode("document.getElementsByClassName('\(DEFINE.MENU_CLOSE_BTN_CLASS)').length") { strLength in
//            if Int(strLength ?? "") ?? 0 > 0 {
//                DispatchQueue.main.async {
//                    self.runJsCode(DEFINE.getMenuCloseOrder())
//                }
//                return
//            }
//        }
//        
//        runJsCode("document.getElementsByClassName('\(DEFINE.ROUTER_BACK_BTN_CLASS)').length") { strLength in
//            if Int(strLength ?? "") ?? 0 > 0 {
//                DispatchQueue.main.async {
//                    self.runJsCode(DEFINE.getRouterBackOrder())
//                }
//                return
//            }
//        }
    }
    
    func runJsCode(_ functionName: String, resultCallBack : ((String?)->Void)? = nil) {
        DLog.p("Call JS : \(functionName)")
        curWebView.evaluateJavaScript(functionName , completionHandler: { result, error in
            DLog.p("evaluateJavaScript :: \(functionName)\n result :: \(String(describing: result))\n error :: \(String(describing: error?.localizedDescription)) ")
            if let result = result {
                resultCallBack?("\(result)")
            }
            else {
                DLog.p("not string?")
            }
        })
    }
    
    func runBridgeCode(_ funcNm: String?,_ codable : Codable) {
        DispatchQueue.main.async {
            do {
                let codable = try JSONEncoder().encode(codable)
                let codableStr = String(data: codable, encoding: .utf8) ?? "{\"result\":{\"resultBoolean\": false,\"resultMessage\": \"json To String error\"}}}"
                let callbackFunc = "window.\(Constant.VUE_BRIDGE).\(funcNm ?? "")('\(codableStr)')"
//                let callbackFunc = "window.\(DEFINE.VUE_BRIDGE).\(funcNm ?? "")(\(codableStr))"

                DLog.p("Call JS : \(callbackFunc.split(by: 500)[0])")
                self.printConsole(msg: "\(funcNm) [\(codableStr)]")
                self.curWebView.evaluateJavaScript(callbackFunc , completionHandler: { result, error in
                    DLog.p("evaluateJavaScript :: \(callbackFunc.split(by: 500)[0])\n result :: \(String(describing: result))\n error :: \(String(describing: error?.localizedDescription)) ")
                })
            } catch {
                print(error)
            }
        }

    }
    
    func printConsole(msg: String) {
        DLog.p("printConsole :: [\(msg)]")
        #if DEBUG
        DispatchQueue.main.async {
            let callbackFunc = "console.log('\(msg)')"
            self.curWebView.evaluateJavaScript(callbackFunc , completionHandler: { result, error in
                DLog.p("evaluateJavaScript :: \(callbackFunc.split(by: 100)[0])\n result :: \(String(describing: result))\n error :: \(String(describing: error?.localizedDescription)) ")
            })
        }
        #endif
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}

//MARK: Push Control
//extension WebController {
//    public func fromPushCheck(_ msgId : String?) {
//        guard let msgId = msgId else { return }
//        
//        let model = PushRecieveRequest(
//            token: Preference.shared.get(key: Preference.KEY_TOKEN),
//            msgId: msgId,
//            rcvDtm: "yyyyMMdd HHmmss".getDateFormatter().string(from: Date())
//        )
//        guard let requestModel = try? JSONEncoder().encode(model) as Data else {
//            do {
//                let _ = try JSONEncoder().encode(model) as Data
//            } catch {
//                DLog.p(error)
//            }
//            return
//        }
//        
//        guard let url = URL(string: DEFINE.URL_REQUEST_BASE + DEFINE.URL_RECIEVE_PUSH) else {
//            DLog.p("url convert failed")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//                                 
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = requestModel
//        AF.request(request).response { afResponse in
//            DLog.p("afResponse :: \n\(String(data: afResponse.data!, encoding: .utf8))")
//            guard let data = afResponse.data else {
//                DLog.p("response data is nil")
//                return
//            }
//            
//            guard let baseResponse = try? JSONDecoder().decode(BaseResponseModel.self, from: data) else {
//                DLog.p("baseResponse parsing error")
//                do {
//                    _ = try JSONDecoder().decode(BaseResponseModel.self, from: data)
//                } catch {
//                    DLog.p(error)
//                }
//                return
//            }
//
//            DLog.p("response :: \(baseResponse.header.code)")
//            DLog.p("response :: \(baseResponse.header.message)")
//        }
//    }
//}


//MARK: webview delegate, file Download
extension WebController : WKUIDelegate, WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        progressView.isHidden = true
    }

    @available(iOS 15.0, *)
    func webView(_ webView: WKWebView, decideMediaCapturePermissionsFor origin: WKSecurityOrigin, initiatedBy frame: WKFrameInfo, type: WKMediaCaptureType) async -> WKPermissionDecision {
        .grant
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let mimeType = navigationResponse.response.mimeType else {
            decisionHandler(.allow)
            return
        }

        guard let url = navigationResponse.response.url else {
            decisionHandler(.allow)
            return
        }

        if mimeType == "text/html" {
            decisionHandler(.allow)
            return
        }

        var fileName = getFileNameFromResponse(navigationResponse.response)
        fileName = fileName.removingPercentEncoding ?? fileName
        fileName = fileName.replacingOccurrences(of: "\";", with: "")
        fileName = fileName.replacingOccurrences(of: "\"", with: "")

        downloadData(fromURL: url, fileName: fileName) { success, destinationURL in
            if success, let destinationURL = destinationURL {
                self.fileDownloadedAtURL(url: destinationURL)
            }
        }
        decisionHandler(.cancel)
    }

    private func getFileNameFromResponse(_ response:URLResponse) -> String {
        if let httpResponse = response as? HTTPURLResponse {
            let headers = httpResponse.allHeaderFields
            if let disposition = headers["Content-Disposition"] as? String {
                let components = disposition.components(separatedBy: "filename=")
                if components.count > 1 {
                    return components[1]
                }
            }
        }
        return "\(NSDate().timeIntervalSince1970)"
    }

    private func downloadData(fromURL url:URL,
                              fileName:String,
                              completion:@escaping (Bool, URL?) -> Void) {
        var alreadyCancel = false
        curWebView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            let session = URLSession.shared
            session.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
            let task = session.downloadTask(with: url) { localURL, urlResponse, error in
                if alreadyCancel {
                    return
                }

                if let localURL = localURL {
                    let destinationURL = self.moveDownloadedFile(url: localURL, fileName: fileName)
                    completion(true, destinationURL)
                }
                else {
                    completion(false, nil)
                }
            }

            let alert = UIAlertController(title: "다운로드", message: "다운로드가 진행중입니다 (0%)", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
                alreadyCancel = true
                task.cancel()
                alert.dismiss(animated: true)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)

            self.observationMap[Observers.DownloadFile.name] = task.progress.observe(\.fractionCompleted) { progress, _ in
                DispatchQueue.main.async {
                    alert.message = "다운로드가 진행중입니다 (\(Int(Float(progress.fractionCompleted) * 100))%)"
                    if progress.fractionCompleted == 1.0 {
                        alert.dismiss(animated: true)
                    }
                }
            }

            task.resume()
        }
    }

    private func moveDownloadedFile(url:URL, fileName:String) -> URL {
        let tempDir = NSTemporaryDirectory()
        let destinationPath = tempDir + fileName
        let destinationURL = URL(fileURLWithPath: destinationPath)
        try? FileManager.default.removeItem(at: destinationURL)
        try? FileManager.default.moveItem(at: url, to: destinationURL)
        return destinationURL
    }


    func fileDownloadedAtURL(url: URL) {
        DispatchQueue.main.async {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = self.view.frame
            activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // confirm() 적용
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//MARK: Message Call Functions
extension WebController {
    
    func setBackgroundColor(color:String, isLight: Bool) {
        DLog.p("setBackgroundColor :: \(color) / \(isLight)")
        if #available(iOS 13.0, *) {
            runBridgeCode("setBackgroundColorResult", BaseResultDomain(resultMessage: "success", resultBoolean: true))
        }
        else {
            runBridgeCode("setBackgroundColorResult", BaseResultDomain(resultMessage: "iOS version is under 13", resultBoolean: false))
            return
        }

        view.backgroundColor = color.toUIColor

        setTopAreaColor(color: color, isLight: isLight, isFromBack: true)
        setBottomAreaColor(color: color, isLight: isLight, isFromBack: true)
    }

    func setTopAreaColor(color:String, isLight: Bool, isFromBack: Bool = false) {
        topAreaView.backgroundColor = color.toUIColor
        if #available(iOS 13.0, *) {
            view.window?.overrideUserInterfaceStyle = isLight ? .light : .dark
            if !isFromBack {
                runBridgeCode("setTopAreaColorResult", BaseResultDomain(resultMessage: "success", resultBoolean: true))
            }
            return
        }

        if !isFromBack {
            runBridgeCode("setTopAreaColorResult", BaseResultDomain(resultMessage: "iOS version is under 13", resultBoolean: false))
        }
    }

    func setBottomAreaColor(color:String, isLight: Bool, isFromBack: Bool = false) {
        bottomAreaView.backgroundColor = color.toUIColor
        if #available(iOS 13.0, *) {
            view.window?.overrideUserInterfaceStyle = isLight ? .light : .dark
            if !isFromBack {
                runBridgeCode("setBottomAreaColorResult", BaseResultDomain(resultMessage: "success", resultBoolean: true))
            }
            return
        }
        if !isFromBack {
            runBridgeCode("setBottomAreaColorResult", BaseResultDomain(resultMessage: "iOS version is under 13", resultBoolean: false))
        }
    }

    func uploadData(type: String) {
        let result = getDataForUpload(type: type)
        runBridgeCode("uploadDataResult", result)
    }
    
    func uploadData(types: [String]) {
        var resultMap : [String:String] = [:]

        for key in types {
            let result = getDataForUpload(type: key)
                if result.result.resultBoolean {
                    resultMap[key] = result.data!
                } else {
                    resultMap[key] = "null"
                }
        }

        let resultModel = DMDataMapResult(
            result: BaseResultDomain(
                resultMessage: "success",
                resultBoolean: true
            ),
            data: resultMap
        )

        runBridgeCode("uploadDataResult", resultModel)
    }
    
    func getDataForUpload(type: String) -> DMDataResult {
        switch type.lowercased() {
        case UploadDataTypes.fcmToken.name :
            if Preference().isEmpty(key: Preference.KEY_TOKEN) {
                let resultDm = BaseResultDomain(resultMessage: "token is null or empty", resultBoolean: false)
                return DMDataResult(result: resultDm, data: nil)
            }
            
            let token = Preference.shared.get(key: Preference.KEY_TOKEN)
            
            let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
            let dataResult = DMDataResult(result: resultDm, data: token)
            return dataResult
        case UploadDataTypes.deviceId.name :
            let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
            var dataResult = DMDataResult(result: resultDm, data: jdid.getDeviceID())
            return dataResult
        case "log".lowercased() : // only for test
            //print log
            #if DEBUG
                let log = Preference.shared.get(key: Preference.KEY_LOG)
                printConsole(msg: log)
                Preference.shared.remove(key: Preference.KEY_LOG)
            #endif
            let resultDm = BaseResultDomain(resultMessage: "token is null or empty", resultBoolean: false)
            return DMDataResult(result: resultDm, data: nil)
        default:
            let resultDm = BaseResultDomain(resultMessage: "token is null or empty", resultBoolean: false)
            return DMDataResult(result: resultDm, data: nil)
        }
    }
}

//MARK: Webview Wrapper Delegate
extension WebController : UIScrollViewDelegate {
    //block bottom bounce
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
//            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
//        }
//    }
}
