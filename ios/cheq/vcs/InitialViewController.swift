//
//  ViewController.swift
//  cheq
//
//  Created by Isaac Jang on 4/9/24.
//  try to git init

import UIKit
import Then


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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        let main = MainNavVC()
        main.modalPresentationStyle = .fullScreen
        
        if session.userInfo == nil {
            main.defView = LoginViewController()
        }
        else {
            main.defView = MainViewController()
        }
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


