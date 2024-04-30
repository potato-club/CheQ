//
//  WebController.swift
//  dreams
//
//  Created by Admin on 2023/03/28.
//

import Foundation
import UIKit
import WebKit
import MessageUI

import AVFoundation
import Photos
import PhotosUI


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
    
    let progressView : UIProgressView = {
        let v = UIProgressView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.progressViewStyle = .bar
        return v
    }()

    var defUrl = "https://www.naver.com"

    lazy var imagePicker : UIImagePickerController = {
        let v = UIImagePickerController()
        v.delegate = self
        return v
    }()
    
    var swipeAble = true


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        addAreaView()
        addWebView()
//        if DEFINE.URL_BASE != DEFINE.URL_ENT {
//            addProgressBar()
//        }
        addGesture()
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
        let newProcessPool = WKProcessPool()
        curWebView.configuration.processPool = newProcessPool

        let url = URL(string: defUrl)!
        
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
        
//        openCamera(type: "ocr")
        
//        var systemVersion = UIDevice.current.systemVersion
//        DLog.p("systemVersion :: \(systemVersion)")
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

//MARK: Message Handler


//MARK: webview delegate, file Download
extension WebController : WKUIDelegate, WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
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
extension WebController : MFMessageComposeViewControllerDelegate {
    //let smsbody4 = `{"recipients":["01058620091", "01065390091"], "desc":"testMessage"}`
    //webkit.messageHandlers.sendSms.postMessage(smsbody4);
    //send sms
    func sendMessage(message: String, recipients: [String]) {
        
        if (MFMessageComposeViewController.canSendText()) {
            runBridgeCode("sendSmsResult", BaseResultDomain(resultMessage: "success", resultBoolean: true))
            
            let controller = MFMessageComposeViewController()
            controller.body = message
            controller.recipients = recipients
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        runBridgeCode("sendSmsResult", BaseResultDomain(resultMessage: "message can not send", resultBoolean: false))
        
    }
    //result - send message
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        DLog.p(result)
        switch (result) {
            case .cancelled:
                print("Message was cancelled")
            case .failed:
                print("Message failed")
            case .sent:
                print("Message was sent")
            default:
                return
        }
        dismiss(animated: true, completion: nil)
    }
    
//    let bgbody = `{"color":"232323", "isLight":true}`
//    webkit.messageHandlers.setBackgroundColor.postMessage(bgbody);
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
    
    func sendKakao(type: String, templatable: Templatable) {
        if !ShareApi.isKakaoTalkSharingAvailable() {
            //미설치
            runBridgeCode("sendKakaoResult", BaseResultDomain(resultMessage: "kakao not installed", resultBoolean: false))

            openStoreForKakao()
            return
        }
        
        ShareApi.shared.shareDefault(templatable: templatable) {(sharingResult, error) in
            if let error = error {
                DLog.p(error)
                self.runBridgeCode("sendKakaoResult", BaseResultDomain(resultMessage: "can not share : \(error)", resultBoolean: false))
                return
            }

            self.runBridgeCode("sendKakaoResult", BaseResultDomain(resultMessage: "sendKakao success", resultBoolean: true))
            
            if let sharingResult = sharingResult {
                UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
            }
        }
    }

    func sendKakaoCustom(templateId: Int64, templateArgs : [String:String]) {
        if !ShareApi.isKakaoTalkSharingAvailable() {
            //미설치
            runBridgeCode("sendKakaoCustomResult", BaseResultDomain(resultMessage: "kakao not installed", resultBoolean: false))

            //open store
            openStoreForKakao()
            return
        }
        ShareApi.shared.shareCustom(templateId: templateId, templateArgs: templateArgs) { result, error in
            if let error = error {
                DLog.p(error)
                self.runBridgeCode("sendKakaoCustomResult", BaseResultDomain(resultMessage: "can not share : \(error)", resultBoolean: false))
                return
            }

            self.runBridgeCode("sendKakaoCustomResult", BaseResultDomain(resultMessage: "sendKakaoCustom success", resultBoolean: true))

            if let result = result {
                UIApplication.shared.open(result.url, options: [:], completionHandler: nil)
            }
        }
    }

    private func openStoreForKakao() {
        let appId = "362057947"
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openCamera() {
        DispatchQueue.main.async {
            switch self.openCameraType {
            case CameraTypes.ocr.name:
                let cameraVc = CameraVC()
                cameraVc.delegate = self
                self.navigationController?.pushViewController(cameraVc, animated: true)
                break
            case CameraTypes.default500.name:
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
                break
            default:
                self.runBridgeCode("openCameraResult", BaseResultDomain(resultMessage: "type is not match", resultBoolean: false))
                break
            }
        }
    }

    func openGallery() {
        DispatchQueue.main.async {
            switch self.openGalleryType {
            case GalleryTypes.default500.name:
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
                break
            default:
                self.runBridgeCode("openGalleryResult", BaseResultDomain(resultMessage: "type is not match", resultBoolean: false))
                break
            }
        }
    }

    func permissionCheckForGallery(_ result: @escaping (Bool)->Void) {
        switch (PHPhotoLibrary.authorizationStatus()) {
        case .authorized:
            result(true)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    result(true)
                    break
                default :
                    result(false)
                    break
                }
            })
            break
        default:
            result(false)
            self.permissionDenied(type: PermissionTypes.gallery.name)
            break
        }
    }

    func permissionCheckForCamera(_ result: @escaping (Bool)->Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch (status) {
        case .authorized:
            result(true)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if (granted) {
                    result(true)
                    return
                }

                result(false)
            }
            break
        default:
            result(false)
            permissionDenied(type: PermissionTypes.camera.name)
            break
        }
    }
    
    func permissionDenied(type: String) {
        DispatchQueue.main.async {
            var typeText = ""
            var resultMethodName = "openCameraResult"
            if type.lowercased() == PermissionTypes.camera.name {
                typeText = "카메라"
                resultMethodName = "openCameraResult"
            }
            else if type.lowercased() == PermissionTypes.microphone.name {
                typeText = "마이크"
                resultMethodName = "recMicResult"
            }

            var alertText = "개인 정보 설정으로 인해 \(typeText)에 액세스할 수 없는 것 같습니다. 다음을 수행하여 이 문제를 해결할 수 있습니다.\n\n1. 이 앱을 닫습니다.\n\n2. 설정 앱을 엽니다.\n\n3. 아래로 스크롤하여 목록에서 이 앱을 선택합니다.\n\n4. \(typeText) 권한을 켭니다.\n\n5. 이 앱을 열고 다시 시도하십시오."
            var alertButton = "확인"
            var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
            var actionArray : [UIAlertAction] = [goAction]

            if let settingUrl = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(settingUrl) {
                alertText = "개인 정보 설정으로 인해 \(typeText)에 액세스할 수 없는 것 같습니다. 다음을 수행하여 이 문제를 해결할 수 있습니다.\n\n1. 아래의 설정 버튼을 눌러 설정 앱을 엽니다.\n\n2. \(typeText) 권한을 켭니다.\n\n3. 이 앱을 열고 다시 시도하십시오."
                alertButton = "설정"
                goAction = UIAlertAction(title: alertButton, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
                })
                let cancelAction = UIAlertAction(title: "닫기", style: .cancel)
                actionArray = [goAction, cancelAction]
            }

            let alert = UIAlertController(title: "오류", message: alertText, preferredStyle: .alert)
            for action in actionArray {
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)

            self.runBridgeCode(resultMethodName, BaseResultDomain(resultMessage: "permission denied", resultBoolean: false))
        }
    }

    func permissionCheckForMic(completion : @escaping (Bool)->Void) {
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        let recordStatus = AVAudioSession.sharedInstance().recordPermission

        if audioStatus == .authorized &&
                   recordStatus == .granted {
            completion(true)
            return
        }

        if audioStatus == .denied  {
            permissionDenied(type: PermissionTypes.microphone.name)
            return
        }

        if recordStatus == .denied {
            permissionDenied(type: PermissionTypes.microphone.name)
            return
        }

        if recordStatus != .granted {
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                if granted {
                    self.permissionCheckForMic(completion: completion)
                    return
                }
                completion(false)
            })
            return
        }

        if audioStatus != .authorized {
            AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                completion(granted)
            }
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
        case UploadDataTypes.deviceName.name :
            let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
            var dataResult : DMDataResult
            if #available(iOS 16.0, *) {
                dataResult = DMDataResult(result: resultDm, data: UIDevice.modelName)
            } else {
                dataResult = DMDataResult(result: resultDm, data: UIDevice.current.name)
            }
            return dataResult
        case UploadDataTypes.osVersion.name :
            let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
            let dataResult = DMDataResult(result: resultDm, data: "\(UIDevice.current.systemVersion)")
            return dataResult
        case UploadDataTypes.resolution.name :
            let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
            let width : Int = Int(screenWidth * screenScale)
            let heigth : Int = Int(screenHeight * screenScale)
            let dataResult = DMDataResult(result: resultDm, data: "\(width)*\(heigth)")
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
    
    func copyToClipBoard(copyData: String) {
        UIPasteboard.general.string = copyData
        let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
        runBridgeCode("copyToClipBoardResult", resultDm)
    }

    func requestPermission(_ permissionType: String) {
        DispatchQueue.main.async {
            switch (permissionType) {
            case PermissionTypes.camera.name :
                self.permissionCheckForCamera { b in
                    let resultDm = BaseResultDomain(resultMessage: b ? "success" : "failed", resultBoolean: b)
                    self.runBridgeCode("reqPermissionResult", resultDm)
                }
                break
            case PermissionTypes.microphone.name :
                self.permissionCheckForMic { b in
                    let resultDm = BaseResultDomain(resultMessage: b ? "success" : "failed", resultBoolean: b)
                    self.runBridgeCode("reqPermissionResult", resultDm)
                }
                break
            default:
                let resultDm = BaseResultDomain(resultMessage: "not matching type", resultBoolean: false)
                self.runBridgeCode("reqPermissionResult", resultDm)
                break
            }
        }
    }
}

//MARK: Camera/Gallery Delegate for Image Picker
extension WebController : UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)

        let resultName = openType == OpenMediaTypes.camera ? "openCameraResult" : "openGalleryResult"

        guard let selectedImage = info[.originalImage] as? UIImage else {
            DLog.p("Image not found!")
            self.runBridgeCode(resultName, BaseResultDomain(resultMessage: "Image not found", resultBoolean: false))
            return
        }

        if openType == OpenMediaTypes.gallery {
            switch openGalleryType {
            case GalleryTypes.default500.name :
                let resizedImage = selectedImage.resize(size: CGSize(width: 500, height: 500))
                let base64Str = resizedImage.jpegData(compressionQuality: 80)?.base64EncodedString()
                let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
                let cameraResult = DMDataResult(result: resultDm, data: base64Str ?? "error")
                self.runBridgeCode(resultName, cameraResult)
                break
            default :
                self.runBridgeCode(resultName, BaseResultDomain(resultMessage: "type not match", resultBoolean: false))
                break
            }
            return
        }
        
        switch openCameraType.lowercased() {
        case CameraTypes.ocr.name :
            let base64Str = selectedImage.jpegData(compressionQuality: 80)?.base64EncodedString()
            let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
            let cameraResult = DMDataResult(result: resultDm, data: base64Str ?? "error")
            self.runBridgeCode(resultName, cameraResult)
            break
        case CameraTypes.default500.name :
            let resizedImage = selectedImage.resize(size: CGSize(width: 500, height: 500))
            let base64Str = resizedImage.jpegData(compressionQuality: 80)?.base64EncodedString()
            let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
            let cameraResult = DMDataResult(result: resultDm, data: base64Str ?? "error")
            self.runBridgeCode(resultName, cameraResult)
            break
        default:
            self.runBridgeCode(resultName, BaseResultDomain(resultMessage: "type not match", resultBoolean: false))
            break
        }
    }


}

//MARK: Camera Delegate
extension WebController : CameraViewDelegate {
    func takePhoto(_ img: UIImage) {
        switch openCameraType.lowercased() {
        case CameraTypes.ocr.name :
            guard let base64Image = img.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
                let resultDm = BaseResultDomain(resultMessage: "base64 converting error", resultBoolean: false)
                self.runBridgeCode("openCameraResult", resultDm)
                return
            }
            
            let resultDm = BaseResultDomain(resultMessage: "success", resultBoolean: true)
            let dataResult = DMDataResult(result: resultDm, data: base64Image)
            runBridgeCode("openCameraResult", dataResult)
            break
        default:
            let resultDm = BaseResultDomain(resultMessage: "openCameraType is not allowed", resultBoolean: false)
            let cameraResult = DMDataResult(result: resultDm, data: nil)
            self.runBridgeCode("openCameraResult", cameraResult)
            DLog.p("openCameraType is not allowed")
            break
        }
        
        self.navigationController?.popViewController(animated: true)
    }

    func cancel(_ msg: String) {
        let resultDm = BaseResultDomain(resultMessage: "cancel : \(msg)", resultBoolean: false)
        self.runBridgeCode("openCameraResult", resultDm)
        DLog.p("cancel :: \(msg)")
        self.navigationController?.popViewController(animated: true)
    }

    func failed(_ msg: String) {
        let resultDm = BaseResultDomain(resultMessage: "failed : \(msg)", resultBoolean: false)
        self.runBridgeCode("openCameraResult", resultDm)
        DLog.p("failed :: \(msg)")
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: Webview Wrapper Delegate
extension WebController : UIScrollViewDelegate {
    //block bottom bounce
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
    }
}
