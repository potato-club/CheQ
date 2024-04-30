//
//  RequestHelper.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//

import Foundation

class RequestConstant {
    
    public static let shared = RequestConstant()
    
    private let headers: [String:String] = [
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-origin",
        "X-Requested-With": "XMLHttpRequest",
        "sec-ch-ua-mobile": "?0",
        "host": "m.hansei.ac.kr"
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
            "%40d1%23USER_ID=\(cParam["id"] ?? "")&%40d1%23directLoginYn=\(cParam["directLoginYn"] ?? "")&%40d1%23str2ndAuth=Y&%40d%23=%40d1%23&%40d1%23=dsParam&%40d1%23tp=dm"
        case .ON_LOAD:
            ""
        case .SEARCH:
            "%40d%23=%40d1%23&%40d1%23=DS_SEARCH&%40d1%23KOR_FNM=\(cParam["name"] ?? "")&%40d1%23STNO=\(cParam["stno"] ?? "")&%40d1%23UNV_GRSC_DV=\(cParam["unvGrscDv"] ?? "")"
        case .MENU_INFO:
            "_AUTH_MENU_KEY=\(cParam["authMenuKey"] ?? "")"
        }
    }
    
    func requestIdCheck(id: String) async -> RequestResult<ResponseCheckID> {
//        var headers = headers
        
        let parameters = getParamBody(.CHECK_ID, cParam: ["id":id])
        return await request(headers: headers,
                             url: Constant.URL_CHECK_ID,
                             parameters: parameters,
                             of: ResponseCheckID.self)
    }
    
    func requestUserStatus(id: String) async -> RequestResult<ResponseUserStatus> {
//        var headers = headers
        
        let parameters = getParamBody(.USER_STATUS, cParam: ["id":id])
        return await request(headers: headers,
                             url: Constant.URL_USER_STATUS,
                             parameters: parameters,
                             of: ResponseUserStatus.self)
    }
    
    func requestPushNoti(id: String) async -> RequestResult<ResponsePushNoti> {
//        var headers = headers
        
        let parameters = getParamBody(.PUSH_NOTI, cParam: ["id":id])
        return await request(headers: headers,
                             url: Constant.URL_PUSH_NOTI,
                             parameters: parameters,
                             of: ResponsePushNoti.self)
    }
    
    
    func requestChkAuthResult(id: String, tid: String) async -> RequestResult<ResponseChkAuthResult> {
//        var headers = headers
        
        let parameters = getParamBody(.CHK_AUTH_RESULT, cParam: ["id":id, "tid":tid])
        return await request(headers: headers,
                             url: Constant.URL_CHK_AUTH_RESULT,
                             parameters: parameters,
                             of: ResponseChkAuthResult.self)
    }
    
    func requestLoginDo(id: String, verified: Bool) async -> RequestResult<ResponseLogin> {
//        let headers = headers
        
        let parameters = getParamBody(.LOGIN_DO, cParam: ["id":id, "directLoginYn": verified ? "Y" : "N"])
        return await request(headers: headers,
                             url: Constant.URL_LOGIN,
                             parameters: parameters,
                             of: ResponseLogin.self)
    }
    
    func requestLoad(id: String, cookie: String) async -> RequestResult<ResponseLoad> {
        var headers = headers
//        headers.add(name: "Cookie", value: cookie)
        headers["Cookie"] = cookie
        
        let parameters = getParamBody(.ON_LOAD, cParam: ["id":id])
        return await request(headers: headers,
                             url: Constant.URL_ON_LOAD,
                             parameters: parameters,
                             of: ResponseLoad.self)
    }
    
    func requestSearch(userInfo: DmUserInfo, cookie: String) async -> RequestResult<ResponseSearch> {
        var headers = headers
//        headers.add(name: "Cookie", value: cookie)
        headers["Cookie"] = cookie
        
        let cParam = ["name":userInfo.gUserNo ?? "", "stno":userInfo.gUserNo ?? "", "unvGrscDv":userInfo.gUnvGrscDv ?? ""]
        let parameters = getParamBody(.SEARCH, cParam: cParam)
        return await request(headers: headers,
                             url: Constant.URL_SEARCH,
                             parameters: parameters,
                             of: ResponseSearch.self)
    }
    
    func requestMenuInfo(cookie: String, authMenuKey: String = "") async -> RequestResult<ResponseMenuInfo> {
        var headers = headers
//        headers.add(name: "Cookie", value: cookie)
        headers["Cookie"] = cookie
        
        let parameters = getParamBody(.MENU_INFO, cParam: ["authMenuKey": authMenuKey])
        return await request(headers: headers,
                             url: Constant.URL_MENU_INFO,
                             parameters: parameters,
                             of: ResponseMenuInfo.self)
    }
    
    func request<T: Decodable>(
        headers: [String:String],
        url: String,
        parameters: String,
        method: HTTPMethod = .POST,
        of type: T.Type = T.self
    ) async -> RequestResult<T> {
        
        let postData =  parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: url)!)
        
        for key in headers.keys {
            request.addValue(headers[key]!, forHTTPHeaderField: key)
        }
        
        request.httpMethod = method.rawValue
        request.httpBody = postData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return RequestResult(success: false, message: "response Error")
            }
            
            if let cookie = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                DataSession.shared.lastCookie = cookie
            }
            
            let result = try JSONDecoder().decode(type, from: data)
            return RequestResult(success: true, message: "success", result: result)

        } catch {
            //handle error
            DLog.p(error)
            return RequestResult(success: false, message: "catch Error", error: error)
        }
        
//        let result = await AF.request(url) { urlRequest in
//            urlRequest.method = .post
//            urlRequest.headers = headers
//            
//            urlRequest.timeoutInterval = 5
//            urlRequest.allowsConstrainedNetworkAccess = false
//            urlRequest.httpBody = parameters.data(using: .utf8)
//        }
//            .serializingDecodable(type)
//            .response
//        
//        if let cookie = result.response?.headers["Set-Cookie"] {
//            DataSession.shared.lastCookie = cookie
//        }
//        return result
    }
}

struct RequestConstantResult<T : Codable> {
    var result : T? = nil
    var errorInfo : Errmsginfo? = nil
    var error : Error? = nil
}
