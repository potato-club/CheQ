//
//  RequestManager.swift
//  cheq
//
//  Created by Isaac Jang on 4/16/24.
//

import Foundation
import UIKit

class RequestManager {
    public static let shared = RequestManager()
    
    let reqHelper = RequestConstant.shared
    
    func requestCheckId(id: String) async throws -> RequestResult<String> {
        let response = await reqHelper.requestIdCheck(id: id)

        if let error = response.error {
            DLog.p(error.localizedDescription)
            return RequestResult(success: false, message: error.localizedDescription)
        }

        guard let result = response.result else {
            return RequestResult(success: false, message: "response value is nil")
        }
        
        guard let strIDYn = result.dmCheckID?.strIDYn else {
            return RequestResult(success: false, message: "response value is nil (2)")
        }
        
        if let errmsginfo = result.errmsginfo?.errmsg {
            return RequestResult(success: false, message: errmsginfo)
        }
        
        
        if strIDYn != "Y" {
            return RequestResult(success: false, message: "N_Custom")
            
        }
        
        return RequestResult(success: true, message: "success")
    }
    
    func requestUserStatus(id: String) async throws -> RequestResult<String> {
        let response = await reqHelper.requestUserStatus(id: id)

        if let error = response.error {
            DLog.p(error.localizedDescription)
            return RequestResult(success: false, message: error.localizedDescription)
        }

        guard let result = response.result else {
            return RequestResult(success: false, message: "response value is nil")
        }
        
        if result.dmUserStatus.returnCode != "0000" {
            return RequestResult(success: false, message: result.dmUserStatus.returnMessage)
        }
        
        return RequestResult(success: true, message: result.dmUserStatus.returnMessage)
    }
    
    func requestPushNoti(id: String) async throws -> RequestResult<DMResultModel> {
        let response = await reqHelper.requestPushNoti(id: id)
        
        if let error = response.error {
            DLog.p(error.localizedDescription)
            return RequestResult(success: false, message: error.localizedDescription)
        }

        guard let result = response.result?.dmPushNoti else {
            return RequestResult(success: false, message: "response value is nil")
        }
        
        return RequestResult(success: true, message: "success", result: result)
    }
    
    func requestAuthResult(id: String, tid: String) async throws -> RequestResult<DMResultModel> {
        let response = await reqHelper.requestChkAuthResult(id: id, tid: tid)
        print("response : \(response)")
        
        
        if let error = response.error {
            DLog.p(error.localizedDescription)
            return RequestResult(success: false, message: error.localizedDescription)
        }

        guard let result = response.result?.dmChkAuthResult else {
            return RequestResult(success: false, message: "response value is nil")
            
        }
        return RequestResult(success: true, message: "success", result: result)
    }
    
    func requestLogin(id: String, verified: Bool = false) async throws -> RequestResult<String> {
        let response = await reqHelper.requestLoginDo(id: id, verified: verified)
        
        if let error = response.error {
            DLog.p(error.localizedDescription)
            return RequestResult(success: false, message: error.localizedDescription)
        }

        guard let result = response.result else {
            return RequestResult(success: false, message: "response value is nil")
        }
        
        if response.result?.metadata.success != true {
            return RequestResult(success: false, message: "success value not true")
        }
        
        return RequestResult(success: true, message: "success")
    }
    
    func requestLoad(id: String) async throws -> RequestResult<DmUserInfo> {
        if DataSession.shared.lastCookie == Preference.NIL {
            return RequestResult(success: false, message: "cookie is nil")
        }
        
        let response = await reqHelper.requestLoad(id: id, cookie: DataSession.shared.lastCookie)
        
        if let error = response.error {
            DLog.p(error.localizedDescription)
            return RequestResult(success: false, message: error.localizedDescription)
        }

        guard let result = response.result?.dmUserInfo else {
            return RequestResult(success: false, message: "response value is nil")
        }
        
        print("result : \(result)")
        
        return RequestResult(success: true, message: "success", result: result)
    }
    
    func requestSearch(userInfo: DmUserInfo) async throws -> RequestResult<SearchResultModel> {
        if DataSession.shared.lastCookie == Preference.NIL {
            return RequestResult(success: false, message: "cookie is nil")
        }
        
        let response = await reqHelper.requestSearch(userInfo: userInfo, cookie:  DataSession.shared.lastCookie)
        
        if let error = response.error {
            DLog.p(error.localizedDescription)
            return RequestResult(success: false, message: error.localizedDescription)
        }

        guard let result = response.result?.dsSreg else {
            return RequestResult(success: false, message: "response value is nil")
        }
        
        return RequestResult(success: true, message: "success", result: result.first)
    }
    
    func requestMenuInfo(id: String) async throws -> RequestResult<ResponseMenuInfo> {
        if DataSession.shared.lastCookie == Preference.NIL {
            return RequestResult(success: false, message: "cookie is nil")
        }
        
        let response = await reqHelper.requestMenuInfo(cookie: DataSession.shared.lastCookie)
        
        if let error = response.error {
            DLog.p(error.localizedDescription)
            return RequestResult(success: false, message: error.localizedDescription)
        }

        if let error = response.result?.errmsginfo {
            return RequestResult(success: false, message: error.errmsg)
        }
        
        guard let result = response.result else {
            return RequestResult(success: false, message: "response value is nil")
        }
        
        print("result : \(result)")
        
//        return RequestResult(success: true, message: "success", result: result)
        return RequestResult(success: true, message: "success", result: result)
    }
    
    
    
//    func requestUserPhoto() async throws -> RequestResult<String> {
//        
//        guard let userInfo = DataSession.shared.userInfo else {
//            return RequestResult(success: false, message: "user is nil")
//        }
//        
//        let responseSearch = try await requestSearch(userInfo: userInfo)
//        
//        guard let searchResult = responseSearch.result,
//              responseSearch.success
//        else {
//            print("responseSearch is Not Y : \(responseSearch.success) \(responseSearch.message)")
//            return RequestResult(success: false, message: responseSearch.message)
//        }
//        
//        guard let photo = searchResult.photo else {
//            return RequestResult(success: false, message: "등록된 사진이 없는 것 같습니다.")
//        }
//        
//        let imageURL = URL(string: photo)! // 이미지 URL 입력
//        let base64Data = try await getBase64DataFromImageURL(imageURL: imageURL)
//        Preference.shared.save(value: base64Data, key: Preference.KEY_USER_PHOTO)
//        
//        return RequestResult(success: true, message: "success", result: base64Data)
//    }
//    
//    func getBase64DataFromImageURL(imageURL: URL) async throws -> String {
//        let (data, _) = try await URLSession.shared.data(from: imageURL)
//        return data.base64EncodedString()
//    }

}


struct RequestResult<T : Codable> {
    let success : Bool
    let message : String
    var result : T? = nil
    var errorInfo : Errmsginfo? = nil
    var error : Error? = nil
}
