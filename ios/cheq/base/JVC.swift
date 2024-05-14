//
//  JVC.swift
//  cheq
//
//  Created by Isaac Jang on 4/11/24.
//

import Foundation
import UIKit
import CoreBluetooth
import CoreLocation

class JVC : UIViewController {
    public var screenWidth : CGFloat = UIScreen.main.bounds.size.width
    public var screenHeight : CGFloat = UIScreen.main.bounds.size.height
    public var screenScale : CGFloat = UIScreen.main.scale
    
    let pref = Preference.shared

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let reqManager = RequestManager.shared
    let session = DataSession.shared
    
    
    //bluetooth
    public lazy var centralManager : CBCentralManager = CBCentralManager(delegate: self, queue: nil)
    var btMap : [String] = []
    //location
    lazy var locationManager = CLLocationManager.init()              // locationManager 초기화.
    var lastBeacon : CLBeacon? = nil
    
    func baseUserAgent() -> String {
        return "##CheQApp/\(Bundle.main.versionName)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        appDelegate.changeOrientation = true
    }
    
    
}
