//
//  WebBridgeExtension.swift
//  cheq
//
//  Created by Isaac Jang on 4/30/24.
//

import Foundation
import UIKit
import WebKit
import MessageUI

import AVFoundation
import Photos
import PhotosUI



extension WebController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard let bodyString = message.body as? String else {
            DLog.p("userContentController message.body error - 1")
            return
        }
        guard let bodyData = bodyString.data(using: .utf8) else {
            DLog.p("userContentController bodyString.data error - 1")
            return
        }
        
        //sendMessage
        
        //setBackgroundColor
        if message.name == BridgeList.setBackgroundColor.rawValue {
            guard let domain = try? JSONDecoder().decode(DMSetBgColor.self, from: bodyData) as DMSetBgColor else {
                let _ = try! JSONDecoder().decode(DMSetBgColor.self, from: bodyData) as DMSetBgColor
                DLog.p("\(message.name) error parsing ::")
                return
            }
            
            setBackgroundColor(color: domain.color, isLight: domain.isLight)
            return
        }
        if message.name == BridgeList.setTopAreaColor.rawValue {
            guard let domain = try? JSONDecoder().decode(DMSetBgColor.self, from: bodyData) as DMSetBgColor else {
                let _ = try! JSONDecoder().decode(DMSetBgColor.self, from: bodyData) as DMSetBgColor
                DLog.p("\(message.name) error parsing ::")
                runBridgeCode("setTopAreaColorResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                return
            }
            
            setTopAreaColor(color: domain.color, isLight: domain.isLight)
            return
        }
        if message.name == BridgeList.setBottomAreaColor.rawValue {
            guard let domain = try? JSONDecoder().decode(DMSetBgColor.self, from: bodyData) as DMSetBgColor else {
                let _ = try! JSONDecoder().decode(DMSetBgColor.self, from: bodyData) as DMSetBgColor
                DLog.p("\(message.name) error parsing ::")
                runBridgeCode("setBottomAreaColorResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                return
            }
            
            setBottomAreaColor(color: domain.color, isLight: domain.isLight)
            return
        }
        
        if message.name == BridgeList.sendKakao.rawValue {
            guard let domain = try? JSONDecoder().decode(DMKakaoShare.self, from: bodyData) as DMKakaoShare else {
                do {
                    let _ = try JSONDecoder().decode(DMKakaoShare.self, from: bodyData) as DMKakaoShare
                } catch {

                    DLog.p(error)
                    runBridgeCode("sendKakaoResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                }
                DLog.p("\(message.name) error parsing ::")
                return
            }
            
            var template : Templatable? = nil
            
            switch (domain.type.lowercased()) {
            case "feed" : template = domain.feedTemplate
            case "list" : template = domain.listTemplate
            case "location" : template = domain.locationTemplate
            case "Commerce" : template = domain.commerceTemplate
            case "text" : template = domain.textTemplate
            default : template = nil
            }
            
            guard let template = template else {
                DLog.p("template is nil :: \(domain.type)")
                return
            }
            
            sendKakao(type: domain.type, templatable: template)
            return
        }

        if message.name == BridgeList.sendKakaoCustom.rawValue {
            guard let domain = try? JSONDecoder().decode(DMKakaoShareCustom.self, from: bodyData) as DMKakaoShareCustom else {
                do {
                    let _ = try JSONDecoder().decode(DMKakaoShareCustom.self, from: bodyData) as DMKakaoShareCustom
                } catch {
                    DLog.p(error)
                    runBridgeCode("sendKakaoCustomResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                }
                DLog.p("\(message.name) error parsing ::")
                return
            }

//            let templateId = domain.templateId

//            let bundleID = Bundle.main.bundleIdentifier ?? "com.daekyo.dreams"
//            if !bundleID.contains("stg") && !bundleID.contains("dev")
//                       && templateId == 98291 {
//                templateId = 98486
//            }

            sendKakaoCustom(templateId: domain.templateId, templateArgs: domain.templateArgs)
            return
        }
        
        
        if message.name == BridgeList.openCamera.rawValue {
            openType = OpenMediaTypes.camera

            guard let domain = try? JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel else {
                do {
                    let _ = try JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel
                } catch {
                    DLog.p("error")
                    runBridgeCode("openCameraResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                }
                DLog.p("\(message.name) error parsing ::")
                return
            }
            openCameraType = domain.type

            permissionCheckForCamera { b in
                if b {
                    self.openCamera()
                    return
                }
                self.runBridgeCode("openCameraResult", BaseResultDomain(resultMessage: "permission denied", resultBoolean: false))
            }
            return
        }

        if message.name == BridgeList.openGallery.rawValue {
            openType = OpenMediaTypes.gallery

            guard let domain = try? JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel else {
                do {
                    let _ = try JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel
                } catch {
                    DLog.p("error")
                    runBridgeCode("openGalleryResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                }
                DLog.p("\(message.name) error parsing ::")
                return
            }
            openGalleryType = domain.type

            permissionCheckForGallery { b in
                if b {
                    self.openGallery()
                    return
                }
                self.runBridgeCode("openGalleryResult", BaseResultDomain(resultMessage: "permission denied", resultBoolean: false))
            }
        }
        
        if message.name == BridgeList.uploadData.rawValue {
            if let domain = try? JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel {
                uploadData(type: domain.type)
                return
            }
            
            if let domain = try? JSONDecoder().decode(DMTypeListModel.self, from: bodyData) as DMTypeListModel {
                uploadData(types: domain.types)
                return
            }
            
            runBridgeCode("uploadDataResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
            return
        }
        
        if message.name == BridgeList.copyToClipboard.rawValue {
            guard let domain = try? JSONDecoder().decode(DMClipBoardCopy.self, from: bodyData) as DMClipBoardCopy else {
                do {
                    let _ = try JSONDecoder().decode(DMClipBoardCopy.self, from: bodyData) as DMClipBoardCopy
                    runBridgeCode("copyToClipboardResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                } catch {
                    DLog.p("error")
                }
                DLog.p("\(message.name) error parsing ::")
                return
            }
            
            copyToClipBoard(copyData: domain.copyData)
            return
        }
        
        if message.name == BridgeList.telNumber.rawValue {
            guard let domain = try? JSONDecoder().decode(DMTelNumber.self, from: bodyData) as DMTelNumber else {
                do {
                    let _ = try JSONDecoder().decode(DMTelNumber.self, from: bodyData) as DMTelNumber
                } catch {
                    DLog.p("error")
                    runBridgeCode("telNumberResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                }
                DLog.p("\(message.name) error parsing ::")
                return
            }
            if let url = URL(string: "tel://\(domain.number)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            else {
                runBridgeCode("telNumberResult", BaseResultDomain(resultMessage: "url parsing error :: \(domain.number)", resultBoolean: false))
            }
            return
        }

        if message.name == BridgeList.reqPermission.rawValue {
            if let domain = try? JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel {
                requestPermission(domain.type)
                return
            }

            runBridgeCode("reqPermissionResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
            return
        }

        if message.name == BridgeList.versionCheck.rawValue {
            if let domain = try? JSONDecoder().decode(DMVersionCheck.self, from: bodyData) as DMVersionCheck {
                let newVersionArr = domain.appVerNm.split(separator: ".")
                let originVersionArr = Bundle.main.versionName.split(separator: ".")

                for i in 0 ..< 3 {
                    let newVersion: Int = newVersionArr.count > i ? Int(newVersionArr[i]) ?? 0 : 0
                    let originVersion: Int = originVersionArr.count > i ? Int(originVersionArr[i]) ?? 0 : 0
                    if newVersion <= originVersion {
                        continue
                    }
                    // have to update
                    var defTitle = "업데이트"
                    var defText = "업데이트가 있습니다."

                    var cancelAction : UIAlertAction
                    if i == 0 {
                        defTitle = "필수\(defTitle)"
                        defText = "필수\(defText)\n업데이트 하지 않으면 앱을 사용할 수 없습니다."

                        cancelAction = UIAlertAction(title: "앱 종료", style: .cancel, handler: { action in
                            self.runBridgeCode("versionCheckResult", BaseResultDomain(resultMessage: "user denied update ( close app )", resultBoolean: false))
                            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                exit(0)
                            }
                        })
                    }
                    else {
                        cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: { action in
                            self.runBridgeCode("versionCheckResult", BaseResultDomain(resultMessage: "user denied update", resultBoolean: false))
                        })
                    }

                    let updateAction = UIAlertAction(title: "업데이트", style: .default, handler: { action in
                        if let url = URL(string: domain.downloadUrl),
                           UIApplication.shared.canOpenURL(url) {
                            DLog.p("url :: \(url.absoluteString)")
                            if url.absoluteString.isEmpty {
                                self.runBridgeCode("versionCheckResult", BaseResultDomain(resultMessage: "url decode failed", resultBoolean: false))
                                return
                            }
//                            UIApplication.shared.open(url)
                            UIApplication.shared.open(url) { b in
                                if b {
                                    self.runBridgeCode("versionCheckResult", BaseResultDomain(resultMessage: "user move to update page", resultBoolean: true))
                                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        exit(0)
                                    }
                                }
                                else {
                                    self.runBridgeCode("versionCheckResult", BaseResultDomain(resultMessage: "url is error 2", resultBoolean: false))
                                }
                            }
                        }
                        else {
                            self.runBridgeCode("versionCheckResult", BaseResultDomain(resultMessage: "url is error", resultBoolean: false))
                        }
                    })

                    let alert = UIAlertController(title: defTitle, message: defText, preferredStyle: .alert)
                    alert.addAction(updateAction)
                    alert.addAction(cancelAction)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                runBridgeCode("versionCheckResult", BaseResultDomain(resultMessage: "lastest version", resultBoolean: false))
                return
            }
            runBridgeCode("versionCheckResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
            return
        }

        if message.name == BridgeList.openBrowser.rawValue {
            guard let domain = try? JSONDecoder().decode(DMUrl.self, from: bodyData) as DMUrl else {
                do {
                    let _ = try JSONDecoder().decode(DMUrl.self, from: bodyData) as DMUrl
                } catch {
                    DLog.p("error")
                    runBridgeCode("openBrowserResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                }
                DLog.p("\(message.name) error parsing ::")
                return
            }

            if let url = URL(string: domain.url), UIApplication.shared.canOpenURL(url) {
                runBridgeCode("openBrowserResult", BaseResultDomain(resultMessage: "success", resultBoolean: true))
                UIApplication.shared.open(url)
            }
            else {
                runBridgeCode("openBrowserResult", BaseResultDomain(resultMessage: "url parsing error", resultBoolean: false))
            }
            return
        }
        
        if message.name == BridgeList.refreshAble.rawValue {
            guard let domain = try? JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel else {
                do {
                    let _ = try JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel
                } catch {
                    DLog.p("error")
                    runBridgeCode("openBrowserResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                }
                DLog.p("\(message.name) error parsing ::")
                return
            }
            
            if OnOffTypes.ON.name.lowercased() == domain.type.lowercased() {
                webViewWrapScroll.refreshControl = refreshControl
            }
            else {
                webViewWrapScroll.refreshControl = nil
            }
//            refreshControl.isEnabled = OnOffTypes.ON.name.lowercased() == domain.type.lowercased()
            runBridgeCode("refreshAbleResult", BaseResultDomain(resultMessage: "success", resultBoolean: true))
            return
        }
        
        if message.name == BridgeList.swipeAble.rawValue {
            guard let domain = try? JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel else {
                do {
                    let _ = try JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel
                } catch {
                    DLog.p("error")
                    runBridgeCode("swipeAbleResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
                }
                DLog.p("\(message.name) error parsing ::")
                return
            }
            
            swipeAble = OnOffTypes.ON.name.lowercased() == domain.type.lowercased()

            runBridgeCode("swipeAbleResult", BaseResultDomain(resultMessage: "success", resultBoolean: true))
            return
        }

        if message.name == BridgeList.devTest.rawValue {
            #if DEBUG
            let appId = "362057947"
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            #endif
        }
    }
}
