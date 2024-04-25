//
//  RequestHelper.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//

import Foundation
import Alamofire

class RequestHelper {
    
    
    private let headers: HTTPHeaders = [
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua-mobile": "?0"
    ]
    
    private func getParamBody(_ requestType: RequestURLType, cParam: [String:String]) -> String {
        return switch requestType {
        case .CHECK_ID:
            "%40d1%23USER_ID=\(cParam["id"] ?? "")&%40d1%23directLoginYn=N&%40d1%23str2ndAuth=Y&%40d%23=%40d1%23&%40d1%23=dsParam&%40d1%23tp=dm"
        case .USER_STATUS:
            "%40d1%23USER_ID=\(cParam["id"] ?? "")&%40d1%23directLoginYn=N&%40d1%23str2ndAuth=Y&%40d%23=%40d1%23&%40d1%23=dsParam&%40d1%23tp=dm"
        case .PUSH_NOTI:
            "%40d1%23strUserName=\(cParam["id"] ?? "")&%40d1%23strTitle=%EC%9D%B8%EC%A6%9D%20%EC%9A%94%EC%B2%AD&%40d1%23strMsg=CheQ%EC%97%90%EC%84%9C%20%EB%A1%9C%EA%B7%B8%EC%9D%B8(2%EC%B0%A8%EC%9D%B8%EC%A6%9D)%EC%9A%94%EC%B2%AD%EC%9D%B4%20%EC%99%94%EC%8A%B5%EB%8B%88%EB%8B%A4.&%40d%23=%40d1%23&%40d1%23=dmPushNoti&%40d1%23tp=dm"
        case .CHK_AUTH_RESULT:
            "%40d1%23strUserName=\(cParam["id"] ?? "")&%40d1%23tid=\(cParam["tid"] ?? "")&%40d%23=%40d1%23&%40d1%23=dmChkAuthResult&%40d1%23tp=dm"
        case .LOGIN_DO:
            "%40d1%23USER_ID=\(cParam["id"] ?? "")&%40d1%23directLoginYn=N&%40d1%23str2ndAuth=Y&%40d%23=%40d1%23&%40d1%23=dsParam&%40d1%23tp=dm"
        case .ON_LOAD:
            ""
        case .SEARCH:
            "%40d%23=%40d1%23&%40d1%23=DS_SEARCH&%40d1%23KOR_FNM=\(cParam["name"] ?? "")&%40d1%23STNO=\(cParam["stno"] ?? "")&%40d1%23UNV_GRSC_DV=\(cParam["unvGrscDv"] ?? "")"
            
        }
    }
    
    func requestIdCheck(id: String) async -> DataResponse<ResponseCheckID, AFError> {
        var headers = headers
        headers.add(name: "host", value: "m.hansei.ac.kr")
        
        let parameters = getParamBody(.CHECK_ID, cParam: ["id":id])
        return await request(headers: headers,
                             url: Constant.URL_CHECK_ID,
                             parameters: parameters,
                             of: ResponseCheckID.self)
    }
    
    func requestUserStatus(id: String) async -> DataResponse<ResponseUserStatus, AFError> {
        var headers = headers
        headers.add(name: "host", value: "m.hansei.ac.kr")
        
        let parameters = getParamBody(.USER_STATUS, cParam: ["id":id])
        return await request(headers: headers,
                             url: Constant.URL_USER_STATUS,
                             parameters: parameters,
                             of: ResponseUserStatus.self)
    }
    
    func requestPushNoti(id: String) async -> DataResponse<ResponsePushNoti, AFError> {
        var headers = headers
        headers.add(name: "host", value: "m.hansei.ac.kr")
        
        let parameters = getParamBody(.PUSH_NOTI, cParam: ["id":id])
        return await request(headers: headers,
                             url: Constant.URL_PUSH_NOTI,
                             parameters: parameters,
                             of: ResponsePushNoti.self)
    }
    
    
    func requestChkAuthResult(id: String, tid: String) async -> DataResponse<ResponseChkAuthResult, AFError> {
        var headers = headers
        headers.add(name: "host", value: "m.hansei.ac.kr")
        
        let parameters = getParamBody(.CHK_AUTH_RESULT, cParam: ["id":id, "tid":tid])
        return await request(headers: headers,
                             url: Constant.URL_CHK_AUTH_RESULT,
                             parameters: parameters,
                             of: ResponseChkAuthResult.self)
    }
    
    func requestLoginDo(id: String) async -> DataResponse<ResponseLogin, AFError> {
        var headers = headers
        headers.add(name: "host", value: "m.hansei.ac.kr")
        
        let parameters = getParamBody(.LOGIN_DO, cParam: ["id":id])
        return await request(headers: headers,
                             url: Constant.URL_LOGIN,
                             parameters: parameters,
                             of: ResponseLogin.self)
    }
    
    func requestLoad(id: String, cookie: String) async -> DataResponse<ResponseLoad, AFError> {
        var headers = headers
        headers.add(name: "host", value: "m.hansei.ac.kr")
        headers.add(name: "Cookie", value: cookie)
        
        let parameters = getParamBody(.ON_LOAD, cParam: ["id":id])
        return await request(headers: headers,
                             url: Constant.URL_ON_LOAD,
                             parameters: parameters,
                             of: ResponseLoad.self)
    }
    
    func requestSearch(userInfo: DmUserInfo, cookie: String) async -> DataResponse<ResponseSearch, AFError> {
        var headers = headers
        headers.add(name: "host", value: "m.hansei.ac.kr")
        headers.add(name: "Cookie", value: cookie)
        
        let cParam = ["name":userInfo.gUserNo ?? "", "stno":userInfo.gUserNo ?? "", "unvGrscDv":userInfo.gUnvGrscDv ?? ""]
        
        DLog.p("cParam : \(cParam)")
        let parameters = getParamBody(.SEARCH, cParam: cParam)
        return await request(headers: headers,
                             url: Constant.URL_SEARCH,
                             parameters: parameters,
                             of: ResponseSearch.self)
    }
    
    func request<T: Decodable>(
        headers: HTTPHeaders,
        url: String,
        parameters: String,
        of type: T.Type = T.self
    ) async -> DataResponse<T, AFError> {
        //        DLog.p("request : \(url)")
        let result = await AF.request(url) { urlRequest in
            urlRequest.method = .post
            urlRequest.headers = headers
            
            urlRequest.timeoutInterval = 5
            urlRequest.allowsConstrainedNetworkAccess = false
            urlRequest.httpBody = parameters.data(using: .utf8)
        }
            .serializingDecodable(type)
            .response
        //        DLog.p("result : \(result)")
        
        if let cookie = result.response?.headers["Set-Cookie"] {
            Preference.shared.save(value: cookie, key: Preference.KEY_LAST_COOKIE)
            DataSession.shared.lastCookie = cookie
        }
        return result
    }
}
