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
//
//
//        if message.name == BridgeList.reqPermission.rawValue {
//            if let domain = try? JSONDecoder().decode(DMTypeModel.self, from: bodyData) as DMTypeModel {
//                requestPermission(domain.type)
//                return
//            }
//
//            runBridgeCode("reqPermissionResult", BaseResultDomain(resultMessage: "decode error", resultBoolean: false))
//            return
//        }

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
