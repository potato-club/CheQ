//
//  IdCardViewController.swift
//  cheq
//
//  Created by Isaac Jang on 4/16/24.
//  try to git init

import Foundation
import UIKit

class IdCardViewController : JVC {
    
    let photoV = UIImageView().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
    }
    
    let nameLabel = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let timeLabel = UILabel().then { v in
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "initialize time..."
    }
    
    let formatter = DateFormatter().then { formatter in
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss" // or "hh:mm a" if you need to have am or pm symbols
    }
    
    @MainActor
    @objc func getCurrentTime() {
        timeLabel.text = formatter.string(from: Date())
    }
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        drawView()
        getCurrentTime()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(getCurrentTime) , userInfo: nil, repeats: true)

        
    }
    /** card
     //image //qr
     
     //KOR_FNM
     //STNO
     //MAJR_ORGNZ_NM
     
     //server-time
     
     //mark
     */
    
    func drawView() {
        
        view.addSubview(photoV)
        view.addSubview(nameLabel)
        view.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            photoV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            photoV.widthAnchor.constraint(equalToConstant: 150),
            photoV.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: photoV.bottomAnchor, constant: 50),
            
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50)
        ])
        
        if let userInfo = session.userInfo {
            let img = userInfo.userPhoto.toUIImage()
            photoV.image = userInfo.userPhoto.toUIImage()
            nameLabel.text = "\(userInfo.userName)(\(userInfo.userNo))/\(userInfo.userMajor)"
        }
        else {
            print("user is nil")
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
}
