//
//  QRViewController.swift
//  cheq
//
//  Created by Isaac Jang on 4/16/24.
//  try to git init

import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

class QRViewController : JVC {
    
    let bar = UIView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        v.cornerRadius = 2.5
    }
    
    let iv = UIImageView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        drawView()
    }
    
    func drawView() {
        view.addSubview(bar)
        view.addSubview(iv)
        
        NSLayoutConstraint.activate([
            bar.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            bar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bar.widthAnchor.constraint(equalToConstant: 100),
            bar.heightAnchor.constraint(equalToConstant: 5),
            
            iv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            iv.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            iv.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            iv.heightAnchor.constraint(equalTo: iv.widthAnchor, multiplier: 1)
        ])
        
        
        
        let image = generateQRCode(from: session.userInfo?.gUserNo ?? "")
        iv.image = image
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    
}
