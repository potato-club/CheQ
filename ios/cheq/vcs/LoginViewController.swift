//
//  LoginViewController.swift
//  cheq
//
//  Created by Isaac Jang on 4/11/24.
//

import Foundation
import UIKit
import WebKit
import Alamofire

class LoginViewController : UIViewController {
    private let loginView = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let loginBtn = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        v.textAlignment = .center
        v.text = "로그인"
    }
    private let lastLoginBtn = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        v.textAlignment = .center
        v.text = "마지막 로그인 테스트"
        v.isUserInteractionEnabled = false
        v.isHidden = true
    }
    
    private let idField = UITextField().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        v.isEnabled = true
    }
    
    private let authVerifyView = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
    }
    
    private let verifyBtn = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        v.textAlignment = .center
        v.text = "인증하기"
    }
    
    private let requestAgainBtn = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        v.textAlignment = .center
        v.text = "다시 보내기"
    }
    
    var lastLoginId = ""
    var lastPushModel : DMResultModel? = nil
    var dmUserInfo : DmUserInfo? = nil
    
    let helper = RequestHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        drawView()
    }
    
    func drawView() {
        
        view.addSubview(loginView)
        
        loginView.addSubview(idField)
        loginView.addSubview(loginBtn)
        loginView.addSubview(lastLoginBtn)
        
        view.addSubview(authVerifyView)
        
        authVerifyView.addSubview(requestAgainBtn)
        authVerifyView.addSubview(verifyBtn)
        
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            loginView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
//            idField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            idField.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 10),
            idField.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: -10),
            idField.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 10),
            idField.heightAnchor.constraint(equalToConstant: 50),
            
            loginBtn.leftAnchor.constraint(equalTo: idField.leftAnchor),
            loginBtn.rightAnchor.constraint(equalTo: idField.rightAnchor),
            loginBtn.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 10),
            loginBtn.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -10),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
            
            lastLoginBtn.topAnchor.constraint(equalTo: loginBtn.topAnchor),
            lastLoginBtn.leftAnchor.constraint(equalTo: loginBtn.leftAnchor),
            lastLoginBtn.rightAnchor.constraint(equalTo: loginBtn.rightAnchor),
            lastLoginBtn.bottomAnchor.constraint(equalTo: loginBtn.bottomAnchor),
            
            authVerifyView.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 10),
            authVerifyView.leftAnchor.constraint(equalTo: loginView.leftAnchor),
            authVerifyView.rightAnchor.constraint(equalTo: loginView.rightAnchor),
            
            requestAgainBtn.topAnchor.constraint(equalTo: authVerifyView.topAnchor),
            requestAgainBtn.leftAnchor.constraint(equalTo: authVerifyView.leftAnchor, constant: 10),
            requestAgainBtn.widthAnchor.constraint(equalToConstant: 50),
            requestAgainBtn.heightAnchor.constraint(equalToConstant: 50),
            requestAgainBtn.bottomAnchor.constraint(equalTo: authVerifyView.bottomAnchor),
            
            verifyBtn.topAnchor.constraint(equalTo: requestAgainBtn.topAnchor),
            verifyBtn.leftAnchor.constraint(equalTo: requestAgainBtn.rightAnchor, constant: 10),
            verifyBtn.rightAnchor.constraint(equalTo: authVerifyView.rightAnchor, constant: -10),
            verifyBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        loginBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickLogin)))
        lastLoginBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickLastLogin)))
        requestAgainBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickRequestAgain)))
        verifyBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickVerify)))
        
        setIdFieldEnable(true)
        setLoginBtnEnable(true)
        
        if !Preference.shared.isEmpty(key: Preference.KEY_USER_ID) {
            idField.text = Preference.shared.get(key: Preference.KEY_USER_ID)
        }
        
        if !Preference.shared.isEmpty(key: Preference.KEY_LAST_COOKIE) {
            //need to check cookie expired
            DataSession.shared.lastCookie = Preference.shared.get(key: Preference.KEY_LAST_COOKIE)
            lastLoginBtn.isUserInteractionEnabled = true
            lastLoginBtn.isHidden = false
        }
    }
    
    @objc func onClickLastLogin() {
        loadUserAndPhoto()
    }
    @objc func onClickLogin() {
        print("onClickLogin")
        setLoginBtnEnable(false)
        guard let id = idField.text, id.count > 1 else {
            //return Alert
            setLoginBtnEnable(true)
            return
        }
        lastLoginId = id
        
        setIdFieldEnable(false)
        
        Task {
            let chkIdResult = try await self.requestCheckId(id: lastLoginId)
            if !chkIdResult.success {
                //show alert
                print("chkIdResult is Not Y : \(chkIdResult)")
                setIdFieldEnable(true)
                setLoginBtnEnable(true)
                return
            }
            print("success chkIdResult")
            
            let userStatusResult = try await self.requestUserStatus(id: lastLoginId)
            if !userStatusResult.success {
                //show alert
                print("chkIdResult is Not Y : \(chkIdResult)")
                setIdFieldEnable(true)
                setLoginBtnEnable(true)
                return
            }
            print("success userStatusResult")
            let pushNotiResult = try await self.requestPushNoti(id: lastLoginId)
            if !pushNotiResult.success {
                print(pushNotiResult.message)
                setIdFieldEnable(true)
                setLoginBtnEnable(true)
            }
            guard let pushResult = pushNotiResult.result,
                  let tid = pushResult.tid,
                  let tidExpired = pushResult.tidExpired
            else {
                print("pushResult tid nil")
                setIdFieldEnable(true)
                setLoginBtnEnable(true)
                return
            }
            lastPushModel = pushResult
            print("success pushNotiResult")
            self.showAuthVerifyBtn()
        }
    }
    
    @objc func onClickRequestAgain() {
        Task {
            let pushNotiResult = try await self.requestPushNoti(id: lastLoginId)
            if !pushNotiResult.success {
                print(pushNotiResult.message)
                setIdFieldEnable(true)
                setLoginBtnEnable(true)
            }
            guard let reesult = pushNotiResult.result, let tidExpired = reesult.tidExpired else {
                print("pushNotiResult is Not Y : \(pushNotiResult.message)")
                setIdFieldEnable(true)
                setLoginBtnEnable(true)
                return
            }
            lastPushModel = reesult
        }
    }
    
    @objc func onClickVerify() {
        guard let tid = lastPushModel?.tid else {
            //error
            print("tid is nil")
            return
        }
        Task {
            let authResult = try await self.requestAuthResult(id: lastLoginId, tid: tid)
            if !authResult.success {
                print("pushNotiResult is Not Y : \(authResult.message)")
                return
            }
            
            let loginResult = try await self.requestLogin(id: lastLoginId)
            if !loginResult.success {
                print("loginResult is Not Y : \(loginResult.message)")
                return
            }
            
            guard let cookie = loginResult.result else {
                print("cookie is nil")
                return
            }
            
            saveUserId(id: lastLoginId)
            loadUserAndPhoto()
        }
    }
    
    @objc func loadUserAndPhoto() {
        Task {
            let responseLoad = try await self.requestLoad()
            guard let loadResult = responseLoad.result,
                  responseLoad.success
            else {
                print("loadResult is Not Y : \(responseLoad.success) \(responseLoad.message) \(responseLoad.result == nil)")
                return
            }
            
            print("responseLoad done")
            
            DataSession.shared.userInfo = loadResult
            
            
            let responseSearch = try await self.requestSearch(userInfo: loadResult)
            
            guard let searchResult = responseSearch.result,
                  responseSearch.success
            else {
                print("responseSearch is Not Y : \(responseSearch.success) \(responseSearch.message)")
                return
            }
            print("searchResult done")
            
            if let photo = searchResult.photo {
                let imageURL = URL(string: photo)! // 이미지 URL 입력
                let base64Data = try await getBase64DataFromImageURL(imageURL: imageURL)
                print(base64Data) // Base64 데이터 출력
            }
            
            print("user id : \(DataSession.shared.userInfo?.gUserNo)")
        }
    }
    
    func getBase64DataFromImageURL(imageURL: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        return data.base64EncodedString()
    }
    
    @MainActor
    func showAuthVerifyBtn() {
        setVerifyBtnEnable(true)
        authVerifyView.isHidden = false
    }
    
    @MainActor
    func setIdFieldEnable(_ val : Bool) {
        idField.isEnabled = val
    }
    
    @MainActor
    func setLoginBtnEnable(_ val : Bool) {
        loginBtn.isUserInteractionEnabled = val
        loginBtn.textColor = val ? .white : .black
        loginBtn.backgroundColor = val ? "#2e2e2e".toUIColor : "#e2e2e2".toUIColor
    }
    
    @MainActor
    func setVerifyBtnEnable(_ val : Bool) {
        verifyBtn.isUserInteractionEnabled = val
        verifyBtn.textColor = val ? .white : .black
        verifyBtn.backgroundColor = val ? "#2e2e2e".toUIColor : "#e2e2e2".toUIColor
    }
    
    @MainActor
    func showProgress() {
        
    }
    
    @MainActor
    func hideProgress() {
        
    }
    
    func saveUserId(id: String) {
        Preference.shared.save(value: id, key: Preference.KEY_USER_ID)
    }
}
// MARK: - Network Functions
extension LoginViewController {
    func requestCheckId(id: String) async throws -> requestResult<String> {
        let response = await helper.requestIdCheck(id: id)
        print("response : \(response)")
        if let error = response.error {
            return requestResult(success: false, message: error.localizedDescription, result: nil)
        }

        guard let result = response.value else {
            return requestResult(success: false, message: "response value is nil", result: nil)
        }
        
        guard let strIDYn = result.dmCheckID?.strIDYn else {
            return requestResult(success: false, message: "response value is nil (2)", result: nil)
        }
        
        if let errmsginfo = result.errmsginfo?.errmsg {
            return requestResult(success: false, message: errmsginfo, result: nil)
        }
        
        
        if strIDYn != "Y" {
            return requestResult(success: false, message: "N_Custom", result: nil)
            
        }
        
        return requestResult(success: true, message: "success", result: nil)
    }
    
    func requestUserStatus(id: String) async throws -> requestResult<String> {
        let response = await helper.requestUserStatus(id: id)
        print("response : \(response)")
        if let error = response.error {
            return requestResult(success: false, message: error.localizedDescription, result: nil)
        }

        guard let result = response.value else {
            return requestResult(success: false, message: "response value is nil", result: nil)
        }
        
        if result.dmUserStatus.returnCode != "0000" {
            return requestResult(success: false, message: result.dmUserStatus.returnMessage, result: nil)
        }
        
        return requestResult(success: true, message: result.dmUserStatus.returnMessage, result: nil)
    }
    
    func requestPushNoti(id: String) async throws -> requestResult<DMResultModel> {
        let response = await helper.requestPushNoti(id: id)
        print("response : \(response)")
        
        if let error = response.error {
            return requestResult(success: false, message: error.localizedDescription, result: nil)
        }

        guard let result = response.value?.dmPushNoti else {
            return requestResult(success: false, message: "response value is nil", result: nil)
        }
        
        return requestResult(success: true, message: "success", result: result)
    }
    
    func requestAuthResult(id: String, tid: String) async throws -> requestResult<DMResultModel> {
        let response = await helper.requestChkAuthResult(id: id, tid: tid)
        print("response : \(response)")
        
        
        if let error = response.error {
            return requestResult(success: false, message: error.localizedDescription, result: nil)
        }

        guard let result = response.value?.dmChkAuthResult else {
            return requestResult(success: false, message: "response value is nil", result: nil)
            
        }
        return requestResult(success: true, message: "success", result: result)
    }
    
    func requestLogin(id: String) async throws -> requestResult<String> {
        let response = await helper.requestLoginDo(id: id)
        
        if let error = response.error {
            return requestResult(success: false, message: error.localizedDescription, result: nil)
        }

        guard let result = response.value else {
            return requestResult(success: false, message: "response value is nil", result: nil)
        }
        
        if response.value?.metadata.success != true {
            return requestResult(success: false, message: "success value not true", result: nil)
        }
        
        guard let cookie = response.response?.headers.dictionary["Set-Cookie"] else {
            return requestResult(success: false, message: "cookie parsing failed", result: nil)
        }
        
        return requestResult(success: true, message: "success", result: cookie)
    }
    
    func requestLoad() async throws -> requestResult<DmUserInfo> {
        let response = await helper.requestLoad(id: lastLoginId, cookie: DataSession.shared.lastCookie ?? "")
        
        if let error = response.error {
            print("----s---")
            print(response.debugDescription)
            print("-----e--")
            return requestResult(success: false, message: error.localizedDescription, result: nil)
        }

        guard let result = response.value?.dmUserInfo else {
            return requestResult(success: false, message: "response value is nil", result: nil)
        }
        
        print("result : \(result)")
        
        return requestResult(success: true, message: "success", result: result)
    }
    
    func requestSearch(userInfo: DmUserInfo) async throws -> requestResult<SearchResultModel> {
        let response = await helper.requestSearch(userInfo: userInfo, cookie:  DataSession.shared.lastCookie ?? "")
        
        if let error = response.error {
            print("----s---")
            print(response.debugDescription)
            print("-----e--")
            return requestResult(success: false, message: error.localizedDescription, result: nil)
        }

        guard let result = response.value?.dsSreg else {
            return requestResult(success: false, message: "response value is nil", result: nil)
        }
        
        return requestResult(success: true, message: "success", result: result.first)
    }
}

struct requestResult<T> {
    let success : Bool
    let message : String
    let result : T?
}
