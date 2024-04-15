//
//  JVC.swift
//  cheq
//
//  Created by Isaac Jang on 4/11/24.
//

import Foundation
import UIKit
//import Alamofire

class JVC : UIViewController {
    public var screenWidth : CGFloat = UIScreen.main.bounds.size.width
    public var screenHeight : CGFloat = UIScreen.main.bounds.size.height
    public var screenScale : CGFloat = UIScreen.main.scale
    
    let pref = Preference.shared

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        appDelegate.changeOrientation = true
    }
}
