//
//  ViewController.swift
//  cheq
//
//  Created by Isaac Jang on 4/9/24.
//  try to git init

import UIKit
import Then
import JDID


class InitialViewController: JVC {
    
    
    let label = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
    }
    
    let iv = UIImageView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "hsu")
    }
    
    
    let account = UIDevice.current.identifierForVendor?.uuidString ?? "" // 기기의 UUID
    let service = Bundle.main.bundleIdentifier ?? "" // 앱의 번들아이덴티파이어

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jdid = UdidLoader(Bundle.main.bundleIdentifier ?? "")
        
        let juid = jdid.getDeviceID()
        print("jdid : \(juid)")
        
        drawView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let main = MainNavVC()
        main.modalPresentationStyle = .fullScreen
        
//        if session.userInfo == nil {
//            main.defView = LoginViewController()
//        }
//        else {
            main.defView = WebController()
//        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = main
    }
    
    private func drawView() {
        view.addSubview(iv)
        
        NSLayoutConstraint.activate([
            iv.topAnchor.constraint(equalTo: view.topAnchor),
            iv.leftAnchor.constraint(equalTo: view.leftAnchor),
            iv.rightAnchor.constraint(equalTo: view.rightAnchor),
            iv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }    
    
    
}


