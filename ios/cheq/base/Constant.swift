//
//  Constant.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//

import Foundation

class Constant {
    static let baseUrl = "https://m.hansei.ac.kr"
    
    private static let URL_MD_LOGIN = "/Login"
    private static let URL_MD_MAIN = "/Main"
    private static let URL_MD_CMBS = "/CMBSregSregLfmnStudM"
    
    static let URL_CHECK_ID = baseUrl + URL_MD_LOGIN + "/checkId.do"
    static let URL_USER_STATUS = baseUrl + URL_MD_LOGIN + "/userStatus.do"
    static let URL_PUSH_NOTI = baseUrl + URL_MD_LOGIN + "/pushNoti.do"
    static let URL_CHK_AUTH_RESULT = baseUrl + URL_MD_LOGIN + "/chkAuthResult.do"
    static let URL_LOGIN = baseUrl + URL_MD_LOGIN + "/login.do"
    
    static let URL_ON_LOAD = baseUrl + URL_MD_MAIN + "/onLoad.do"
    
    static let URL_SEARCH = baseUrl + URL_MD_CMBS + "/search.do"
    static let URL_MENU_INFO = baseUrl + URL_MD_CMBS + "/search.do" // todo

    
}

enum RequestURLType {
    case CHECK_ID,
         USER_STATUS,
         PUSH_NOTI,
         CHK_AUTH_RESULT,
         LOGIN_DO,
         ON_LOAD,
         SEARCH,
         MENU_INFO
    
}


enum HTTPMethod : String {
    case CONNECT
    case DELETE
    case GET
    case HEAD
    case OPTIONS
    case PATCH
    case POST
    case PUT
    case TRACE
}
