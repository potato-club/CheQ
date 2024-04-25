//
//  ViewController.swift
//  cheq
//
//  Created by Isaac Jang on 4/9/24.
//

import UIKit
import Then


class ViewController: UIViewController {
    
    
    let label = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        drawView()
        
        
        
    }
    
    private func drawView() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 100),
            label.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickView)))
    }

    @objc func onClickView() {
        print("onClickView")
//        present(ReadViewController(), animated: true)
        present(LoginViewController(), animated: true)
//        RequestHelper().requestCustom()
    }

    
}


