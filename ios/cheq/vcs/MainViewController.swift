//
//  MainViewController.swift
//  cheq
//
//  Created by Isaac Jang on 4/16/24.
//  try to git init

import Foundation
import UIKit
import Lottie

class MainViewController : JVC {
    
    private let floatingButtonSize = CGSize(width: 60, height: 60)
    private let floatingButtonPadding : CGFloat = 10
    private let floatingMargin : CGFloat = 30
    private let floatingSpacing : CGFloat = 10
    private let floatingAnimationTime : CGFloat = 0.3
    
    
    let label = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        v.text = "MainViewController"
    }
    
    let iv = UIImageView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let logOutLabel = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        v.text = "__[LogOut]__"
        v.textAlignment = .center
        v.isUserInteractionEnabled = true
    }
    
    let floatingMenuBtn = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        v.cornerRadius = 30
        v.isUserInteractionEnabled = true
        v.clipsToBounds = false
        v.setShadow = true
    }
    
    let lottieView : LottieAnimationView = {
        let animView = LottieAnimationView(name:"menu")
        animView.translatesAutoresizingMaskIntoConstraints = false
        animView.contentMode = .scaleAspectFill
        animView.isUserInteractionEnabled = false
        animView.animationSpeed = 3
        return animView
    }()
    
    let menuActiveBackground = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.isHidden = true
        v.alpha = 0
        v.isUserInteractionEnabled = true
    }
    
    
    lazy var ftQR = getFloatingButtonView(named: "qr_code")
    lazy var ftIDCard = getFloatingButtonView(named: "id_card")
    lazy var ftBtnList = [ftQR, ftIDCard]
    lazy var ftBtnConstraintList : [NSLayoutConstraint] = []
    
    
    func getFloatingButtonView(named: String) -> UIView {
        let v = UIView().then { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .gray
            v.clipsToBounds = true
            v.cornerRadius = 30
            v.isUserInteractionEnabled = true
            v.layer.shadowColor = UIColor.black.cgColor
            v.layer.shadowOpacity = 1
            v.isHidden = true
        }
    
        v.setShadow = true
        
        let subView = getIconImageView(named: named)
        v.addSubview(subView)
        
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: v.topAnchor, constant: floatingButtonPadding),
            subView.leftAnchor.constraint(equalTo: v.leftAnchor, constant: floatingButtonPadding),
            subView.rightAnchor.constraint(equalTo: v.rightAnchor, constant: (floatingButtonPadding * -1)),
            subView.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: (floatingButtonPadding * -1)),
            
            v.widthAnchor.constraint(equalToConstant: floatingButtonSize.width),
            v.heightAnchor.constraint(equalToConstant: floatingButtonSize.height),
        ])
        return v
    }

    func getIconImageView(named: String) -> UIImageView {
        return UIImageView(image: UIImage(named: named)).then { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            v.contentMode = .scaleAspectFit
            v.tintColor = .black
        }
    }
    
    
    var isActiveFloating = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        drawView()
        drawFloatingBtn()
    }
    
    
    private func drawView() {
        
        view.addSubview(label)
        view.addSubview(iv)
        view.addSubview(logOutLabel)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            iv.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            iv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            iv.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
            iv.heightAnchor.constraint(equalTo: iv.widthAnchor, multiplier: 1),
            
            logOutLabel.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: 10),
            logOutLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            logOutLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            logOutLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        logOutLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickLogOut)))
    }
    
    @objc func onClickLogOut() {
        pref.remove(key: Preference.KEY_USER_PHOTO)
        session.lastCookie = Preference.NIL
        session.userInfo = nil
        
        if let nav = self.navigationController as? MainNavVC {
            nav.clearPush(vc: LoginViewController())
        }
        else {
            self.dismiss(animated: true)
        }
    }
    
    private func drawFloatingBtn() {
        
        
        view.addSubview(menuActiveBackground)
        
        view.addSubview(ftIDCard)
        view.addSubview(ftQR)
        
        
        view.addSubview(floatingMenuBtn)
        floatingMenuBtn.addSubview(lottieView)
        
        NSLayoutConstraint.activate([
            menuActiveBackground.topAnchor.constraint(equalTo: view.topAnchor),
            menuActiveBackground.leftAnchor.constraint(equalTo: view.leftAnchor),
            menuActiveBackground.rightAnchor.constraint(equalTo: view.rightAnchor),
            menuActiveBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            floatingMenuBtn.widthAnchor.constraint(equalToConstant: floatingButtonSize.width),
            floatingMenuBtn.heightAnchor.constraint(equalToConstant: floatingButtonSize.height),
            floatingMenuBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: (floatingMargin * -1)),
            floatingMenuBtn.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: (floatingMargin * -1)),
            
            lottieView.topAnchor.constraint(equalTo: floatingMenuBtn.topAnchor, constant: floatingButtonPadding),
            lottieView.rightAnchor.constraint(equalTo: floatingMenuBtn.rightAnchor, constant: (floatingButtonPadding * -1)),
            lottieView.leftAnchor.constraint(equalTo: floatingMenuBtn.leftAnchor, constant: floatingButtonPadding),
            lottieView.bottomAnchor.constraint(equalTo: floatingMenuBtn.bottomAnchor, constant: (floatingButtonPadding * -1)),
        ])
        
        for ftBtn in ftBtnList {
            let constriant = ftBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: (floatingMargin * -1))
            ftBtnConstraintList.append(constriant)
            
            NSLayoutConstraint.activate([
                constriant,
                ftBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: (floatingMargin * -1))
            ])
        }
        
        floatingMenuBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFloating)))
        ftIDCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickIdCard)))
        ftQR.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickQrCode)))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadUserInfo()
    }

    
    private func loadUserInfo() {
        
        guard let userInfo = session.userInfo else {
            print("userInfo is nil")
            session.userInfo = nil
            return
        }
        
        label.text = session.userInfo?.userNo
        
        
        if !pref.isEmpty(key: Preference.KEY_USER_PHOTO) {
            let photo = pref.get(key: Preference.KEY_USER_PHOTO)
            iv.image = photo.toUIImage()
        }
        
    }
    
    private func goLogin() {
        
    }
}

// MARK: - Click Events
extension MainViewController {
    
    @objc func onClickLogin() {
        if let nav = self.navigationController {
            nav.pushViewController(LoginViewController(), animated: true)
            return
        }
        present(LoginViewController(), animated: true)
    }
    
    @MainActor
    @objc func onClickFloating() {
        floatingActive(setActive: !isActiveFloating)
    }
    
    @objc func floatingActive(setActive : Bool) {
        if setActive {
            menuActiveBackground.alpha = 0
            menuActiveBackground.isHidden = false
            
            for v in self.ftBtnList {
                v.isHidden = false
            }
            
            UIView.animate(withDuration: floatingAnimationTime, delay: 0, options: .curveEaseInOut, animations: {
                self.menuActiveBackground.alpha = 0.3
                
                for i in 0 ..< self.ftBtnConstraintList.count {
                    let c = self.ftBtnConstraintList[i]
                    let index : CGFloat = CGFloat(i) + CGFloat(1)
                    c.constant = (self.floatingMargin + (self.floatingSpacing * index) + (self.floatingButtonSize.height * index)) * -1
                }
                self.view.layoutIfNeeded()
            })
            lottieView.play(fromProgress: 0, toProgress: 0.5)
        } else {
            UIView.animate(withDuration: floatingAnimationTime, delay: 0, options: .curveEaseInOut, animations: {
                self.menuActiveBackground.alpha = 0
                for c in self.ftBtnConstraintList {
                    c.constant = (self.floatingMargin * -1)
                }
                self.view.layoutIfNeeded()
            }, completion: { Bool in
                for v in self.ftBtnList {
                    v.isHidden = true
                }
            })
            lottieView.play(fromProgress: 0.5, toProgress: 1) {completed in
                self.menuActiveBackground.isHidden = true
            }
        }
        
        
        isActiveFloating = setActive
    }
    
    @objc func onClickQrCode() {
        floatingActive(setActive: false)
        present(QRViewController(), animated: true)
    }
    
    @objc func onClickIdCard() {
        floatingActive(setActive: false)
    }
}
