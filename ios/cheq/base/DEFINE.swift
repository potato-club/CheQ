//
//  DEFINE.swift
//  cheq
//
//  Created by Isaac Jang on 4/11/24.
//

import Foundation

class DEFINE {
//    public static let serverType : SERVER_TYPE = .STAGE
//
//    public static let URL_DRS_BASE_HEAD = "https://drs-gateway"
//    public static let URL_DRS_BASE_TAIL = ".daekyo.co.kr:8080"
//
//    public static let URL_BASE_HEAD = "https://mdreams"
//    public static let URL_BASE_TAIL = ".daekyo.co.kr"
//
//    public static let URL_DEV = "d"
//    public static let URL_STAGE = "s"
//    public static let URL_PRODUCT = ""
//
//    public static func getDreamsUrl(serverType : SERVER_TYPE = DEFINE.serverType) -> String {
//        switch(serverType) {
//        case .DEV :
//            return URL_BASE_HEAD + URL_DEV + URL_BASE_TAIL
//        case .STAGE :
//            return URL_BASE_HEAD + URL_STAGE + URL_BASE_TAIL
//        case .PRODUCT :
//            return URL_BASE_HEAD + URL_PRODUCT + URL_BASE_TAIL
//        }
//    }
//    public static func getDrsUrl(serverType : SERVER_TYPE = DEFINE.serverType) -> String {
//        switch(serverType) {
//        case .DEV :
//            return URL_DRS_BASE_HEAD + URL_DEV + URL_DRS_BASE_TAIL
//        case .STAGE :
//            return URL_DRS_BASE_HEAD + URL_STAGE + URL_DRS_BASE_TAIL
//        case .PRODUCT :
//            return URL_DRS_BASE_HEAD + URL_PRODUCT + URL_DRS_BASE_TAIL
//        }
//    }
//    
//    public static let UsingVerticalSafeArea = true
//    public static let UsingHorizontalSafeArea = false
//    
//    public static let URL_REQUEST_BASE = "https://drs-gatewayd.daekyo.co.kr:8080"
//    public static let URL_RECIEVE_PUSH = "/push/v1/device/check/receive"
//
//
//    public static let VUE_BRIDGE = "app"
//    
//    public static let MENU_CLOSE_BTN_CLASS = "gnb_close"
//    public static let ROUTER_BACK_BTN_CLASS = "btn_back"
//    
//    
//    
//    public static func getMenuCloseOrder() -> String {
//        return """
//        document.getElementsByClassName('\(DEFINE.MENU_CLOSE_BTN_CLASS)')[0].click();
//        """
//    }
//
//    public static func getRouterBackOrder() -> String {
//        return """
//        document.getElementsByClassName('\(DEFINE.ROUTER_BACK_BTN_CLASS)')[0].click();
//        """
//    }
//    
//    
//    public static func getMainMenuList() -> [String] {
//        return [
//            DEFINE.getDreamsUrl() + "/dreams/ad/jnAd",
//            DEFINE.getDreamsUrl() + "/dreams/tcls/tdyTcls/atndnBk",
//            DEFINE.getDreamsUrl() + "/dreams/srch",
//        ]
//    }
//
//    public static let MAIN_HOME_URL_SIMPLE = DEFINE.getDreamsUrl() + "/dreams/home"
}

enum SERVER_TYPE {
    case DEV, STAGE, PRODUCT
}
