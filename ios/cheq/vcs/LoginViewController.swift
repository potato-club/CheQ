//
//  LoginViewController.swift
//  cheq
//
//  Created by Isaac Jang on 4/11/24.
//  try to git init

import Foundation
import UIKit
import WebKit

class LoginViewController : JVC {
    private let loginView = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let loginBtn = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        v.textAlignment = .center
        v.text = "로그인"
    }
    
    private let idField = UITextField().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        v.isEnabled = true
    }
    
//    private let pwField = UITextField().then { v in
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .lightGray
//        v.isEnabled = true
//    }
    
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
    
//    var lastLoginId = ""
    var lastPushModel : DMResultModel? = nil
    var dmUserInfo : DmUserInfo? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        drawView()
    }
    
    func drawView() {
        
        view.addSubview(loginView)
        
        loginView.addSubview(idField)
//        loginView.addSubview(pwField)
        loginView.addSubview(loginBtn)
        
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
            
//            pwField.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 10),
//            pwField.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: -10),
//            pwField.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 10),
//            pwField.heightAnchor.constraint(equalToConstant: 50),
            
            loginBtn.leftAnchor.constraint(equalTo: idField.leftAnchor),
            loginBtn.rightAnchor.constraint(equalTo: idField.rightAnchor),
            loginBtn.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 10),
            loginBtn.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -10),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
            
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
        requestAgainBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickRequestAgain)))
        verifyBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickVerify)))
        
        setIdFieldEnable(true)
        setLoginBtnEnable(true)
        
        if !pref.isEmpty(key: Preference.KEY_USER_ID) {
            idField.text = pref.get(key: Preference.KEY_USER_ID)
        }
    }
    
    @objc func onClickLogin() {
        print("onClickLogin")
        setLoginBtnEnable(false)
        guard let id = idField.text, id.count > 1 else {
            //return Alert
            DLog.p("id error : \(idField.text?.count)")
            setLoginBtnEnable(true)
            return
        }
//        guard let pw = pwField.text, pw.count > 1 else {
//            //return Alert
//            DLog.p("pw error")
//            setLoginBtnEnable(true)
//            return
//        }
        
        setIdFieldEnable(false)
        
        Task {
            let chkIdResult = try await reqManager.requestCheckId(id: id)
            if !chkIdResult.success {
                //show alert
                print("chkIdResult is Not Y : \(chkIdResult)")
                setIdFieldEnable(true)
                setLoginBtnEnable(true)
                return
            }
            print("success chkIdResult")
            
            let userStatusResult = try await reqManager.requestUserStatus(id: id)
            if !userStatusResult.success {
                //show alert
                print("chkIdResult is Not Y : \(chkIdResult)")
                setIdFieldEnable(true)
                setLoginBtnEnable(true)
                return
            }
            print("success userStatusResult")
            let pushNotiResult = try await reqManager.requestPushNoti(id: id)
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
        
        setAgainAuthBtnEnable(false)
        guard let id = idField.text, id.count > 1 else {
            //return Alert
            setAgainAuthBtnEnable(true)
            return
        }
        
        Task {
            let pushNotiResult = try await reqManager.requestPushNoti(id: id)
            if !pushNotiResult.success {
                print(pushNotiResult.message)
                setIdFieldEnable(true)
                setAgainAuthBtnEnable(true)
            }
            guard let reesult = pushNotiResult.result, let tidExpired = reesult.tidExpired else {
                print("pushNotiResult is Not Y : \(pushNotiResult.message)")
                setIdFieldEnable(true)
                setAgainAuthBtnEnable(true)
                return
            }
            lastPushModel = reesult
        }
    }
    
    @objc func onClickVerify() {
        
//        guard let id = idField.text, id.count > 1 else {
//            //return Alert
//            return
//        }
//        
//        guard let tid = lastPushModel?.tid else {
//            //error
//            print("tid is nil")
//            return
//        }
//        
//        Task {
//            let authResult = try await reqManager.requestAuthResult(id: id, tid: tid)
//            if !authResult.success {
//                print("authResult is Not Y : \(authResult.message)")
//                return
//            }
//            
//            let loginResult = try await reqManager.requestLogin(id: id)
//            if !loginResult.success {
//                print("loginResult is Not Y : \(loginResult.message)")
//                return
//            }
//            
//            saveUserId(id: id)
//            
//            let responseLoad = try await reqManager.requestLoad(id: id)
//            guard let loadResult = responseLoad.result,
//                  responseLoad.success
//            else {
//                print("loadResult is Not Y : \(responseLoad.success) \(responseLoad.message) \(responseLoad.result == nil)")
//                return
//            }
//            
//            pref.saveLastUserInfo(m: loadResult)
//            
//            let responseSearch = try await reqManager.requestSearch(userInfo: loadResult)
//            guard let searchResult = responseSearch.result,
//                  responseSearch.success
//            else {
//                print("responseSearch is Not Y : \(responseSearch.success) \(responseSearch.message) \(responseSearch.result == nil)")
//                return
//            }
//            
//            let photoResult = try await reqManager.requestUserPhoto()
//            if let base64 = photoResult.result {
//                pref.save(value: base64, key: Preference.KEY_USER_PHOTO)
//            }
//            else {
//                print("photo is nil")
//            }
//            
//            if let nav = self.navigationController as? MainNavVC {
//                nav.clearPush(vc: MainViewController())
//            }
//        }
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
    func setAgainAuthBtnEnable(_ val : Bool) {
        requestAgainBtn.isUserInteractionEnabled = val
        requestAgainBtn.textColor = val ? .white : .black
        requestAgainBtn.backgroundColor = val ? "#2e2e2e".toUIColor : "#e2e2e2".toUIColor
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
        pref.save(value: id, key: Preference.KEY_USER_ID)
    }
}
// MARK: - Utils
extension LoginViewController {
    
    
}
