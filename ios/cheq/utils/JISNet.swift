////
////  JISNet.swift
////  cheq
////
////  Created by Isaac Jang on 4/19/24.
////
//
//import Foundation
//import UIKit
//
//
//class JISNet {
//
//    // HTTPMethod.CONNECT.rawValue
//    enum HTTPMethod : String {
//        case CONNECT
//        case DELETE
//        case GET
//        case HEAD
//        case OPTIONS
//        case PATCH
//        case POST
//        case PUT
//        case TRACE
//    }
//
//    private var urlComponents = URLComponents()
//    init() {
//        urlComponents.scheme = DEFINE.BASE_SCHEME
//        urlComponents.host = DEFINE.BASE_HOST
//    }
//
//    public func getUrlcomponents() -> URLComponents {
//        return urlComponents
//    }
//
//    //settingValues
//    private var requestMethod : HTTPMethod?
//    private var params : [String: Any]?
//    private var exceptionCodes : [Int] = []
//
////    @discardableResult
////    public func setCallback(_ sc: @escaping ((Data)->Void), _ cf: @escaping ((Int, String)->Void), _ lfc: @escaping ((String)->Void)) -> Self {
////        self.successClosure = sc
////        self.codeFailClosure = cf
////        self.localFailClosure = lfc
////        return self
////    }
//
//    @discardableResult
//    private func setPath (_ pt : String) -> Self{
//        _ = try? urlComponents.asURL()
//        self.urlComponents.path = pt
//        return self
//    }
//
//    @discardableResult
//    private func setQuery (_ qr : String?) -> Self{
//        guard let qr = qr else {
//            return self
//        }
//        _ = try? urlComponents.asURL()
//        self.urlComponents.query = qr
//        //DLog.p("querys : \(qr)")
//        return self
//    }
//    @discardableResult
//    private func setQueryList (_ qi : [URLQueryItem]) -> Self{
//        _ = try? urlComponents.asURL()
//        self.urlComponents.queryItems = qi
//        //DLog.p("querys : \(qi)")
//        return self
//    }
//
//    @discardableResult
//    private func setMethod (_ method: HTTPMethod) -> Self {
//        self.requestMethod = method
//        //DLog.p("method : \(method)")
//        return self
//    }
//
//
//    @discardableResult
//    private func setParams(_ value: [String: Any]?) -> Self {
//        self.params = value
//        return self
//    }
//
//    public func getQueryItem(query: [String:Any]) -> [URLQueryItem] {
//        var querys = [URLQueryItem]()
//        for item in query {
//            querys.append(URLQueryItem(name: item.key, value: "\(item.value)"))
//        }
//        return querys
//    }
//
//    public func setExceptionCodes(codes: [Int]) -> Self {
//        self.exceptionCodes = codes
//        return self
//    }
//
//    //action Methods
//    public func request(path: String, method: HTTPMethod, query: [String:Any]?) {
//        if let q = query {
//            var querys = [URLQueryItem]()
//            for item in q {
//                querys.append(URLQueryItem(name: item.key, value: "\(item.value)"))
//            }
//            self.setQueryList(querys)
//        }
//
//        self.setPath(path)
//        self.setMethod(method)
//        self.request()
//    }
//
//
//    public func request(path: String, method: HTTPMethod, parameters: [String:Any]? = nil) {
//        self.setPath(path)
//        self.setMethod(method)
//        if parameters != nil {
//            self.setParams(parameters)
//        }
//        
//        self.request()
//    }
//
//    public func request(path: String, method: HTTPMethod, query: [String:Any]? = nil, parameters: [String:Any]? = nil) {
//        if let q = query {
//            var querys = [URLQueryItem]()
//            for item in q {
//                querys.append(URLQueryItem(name: item.key, value: "\(item.value)"))
//            }
//            self.setQueryList(querys)
//        }
//
//        if let params = parameters {
//            self.setParams(params)
//        }
//
//        self.setPath(path)
//        self.setMethod(method)
//        self.request()
//    }
//
//    //body Method
//    public func request() async throws {
//        
//        
//        guard let reqUrl = URL(string: url) else {
//            RequestResult(success: <#T##Bool#>, message: <#T##String#>)
//            return RequestError.
//        }
//        var request = URLRequest(url: reqUrl)
//        for head in headers.keys {
//            request.addValue(headers[head], forHTTPHeaderField: head)
//        }
//        
//        
//        guard let requestUrl = try? urlComponents.asURL() else {
//            DLog.p("error url")
//            
//            callLocalFail("requestUrl Error")
//            return
//        }
//
//        guard let method = requestMethod else {
//            DLog.p("error url")
//            callLocalFail("method nil Error")
//            return
//        }
////        DLog.p("requestUrl : \(requestUrl)")
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = method.rawValue
//        request.cachePolicy = .reloadIgnoringLocalCacheData
//
////        DLog.p("requestURL : \(requestUrl)")
//        if let param = params {
////            DLog.p("param : \(param)")
//            request.httpBody = param.percentEncoded()
//        }
//
//        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
//        
//        
//        
//        
//        let (data, response) = try await session.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw RequestError.invalidResponse
//        }
//        
//        
//        
//
//        session.dataTask(with: request) { (data, response, error) in
//            DLog.p("request : \(requestUrl)")
//            guard error == nil else {
//                DLog.p("결과값에 문제가 있습니다.")
//                DispatchQueue.main.async { self.callLocalFail(String(describing:error)) }
//                return
//            }
//            guard let data = data else {
//                DLog.p("Data가 비정상입니다.")
//                DispatchQueue.main.async { self.callLocalFail("Data가 비정상입니다.") }
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                DLog.p("response :: \((response as? HTTPURLResponse)?.statusCode)")
//                DispatchQueue.main.async {
//                    self.callCodeFail(-1, "서버 에러입니다.")
//                }
//                return
//            }
//
//            let jsonString = String(decoding: data, as: UTF8.self)
//
//            DLog.p("data : \(jsonString)")
//            let dict = self.convertToDictionary(text: jsonString)
//
////            guard let body = dict?.object(forKey: "body") as? NSDictionary else {
////                DLog.p("body error")
////                DispatchQueue.main.async { self.callLocalFail("Data가 비정상입니다.") }
////                return
////            }
//
//            guard let apiCode = dict?.object(forKey: "API_CODE") as? NSDictionary else {
//                guard let areaInfo = dict?.object(forKey: "areaInfo") as? NSDictionary else { ///app/v2/main/get_xy_to_addr.json 에서 api_code를 안주어 예외처리
//                    DispatchQueue.main.async {
//                        self.callLocalFail("NO_API_CODE")
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.callSuccess(data)
//                }
//                return
//            }
//
//            let errorCode = Int(apiCode.object(forKey: "rtcode") as! String)
//            let errorMsg = apiCode.object(forKey: "rtmsg") as! String
//            DispatchQueue.main.async {
////                DLog.p("-------- JISNET END ----------")
//                if errorCode != 1 {
//                    DLog.p("erorr code != 1 : \n\(self.params)")
//                    if !self.exceptionCodes.contains(errorCode!) {
//                        self.callCodeFail(errorCode!, errorMsg)
//                        return
//                    }
//                }
//                self.callSuccess(data)
//            }
//        }.resume()
//    }
//    
//    func request() async throws {
////        RequestError
//    }
//
//    public func convertToDictionary(text: String) -> NSDictionary? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
//
////    private func callSuccess(_ params: Data) {
////        self.successClosure?(params)
////    }
////    private func callLocalFail(_ params: String) {
////        self.localFailClosure?(params)
////    }
////    private func callCodeFail(_ code: Int, _ desc: String) {
////        self.codeFailClosure?(code, desc)
////    }
//
////    public func requestCustom(url: String) {
////
////        guard let requestUrl = URL(string: url) else {
////            self.callLocalFail("url Error")
////            return
////        }
////        let session = URLSession.shared
////
////        let dataTask = session.dataTask(with: requestUrl) { (data, response, error) in
////            if data != nil {
////                self.callSuccess(data!)
////            }
////            else {
////                self.callLocalFail("nil Error")
////            }
////        }
////        dataTask.resume()
////    }
//
//
//    public static func getQueryString(querys: [String:Any]) -> String {
//        var isFirst = true
//        var url = "?"
//        for item in querys {
//            if !isFirst {
//                url.append("&")
//            }
//            isFirst = false
//
//            url.append(item.key)
//            url.append("=")
//            if let strValue = item.value as? String {
//                url.append(strValue)
//            }
//            if let strValue = item.value as? Int {
//                url.append("\(strValue)")
//            }
//            if let strValue = item.value as? CGFloat {
//                url.append("\(strValue)")
//            }
//
//        }
//        return url
//    }
//
//}
//
//
//struct RequestResult<T : Codable> {
//    let success : Bool
//    let message : String
//    var result : T? = nil
//    var error : <Error, Errmsginfo>? = nil
//}
//
//struct ErrorModel {
//    var error : Error
//    var errorInfo : Errmsginfo
//}
