//
//  BridgeList.swift
//  cheq
//
//  Created by Isaac Jang on 4/30/24.
//

import Foundation

enum BridgeList: String, CaseIterable {
    case hideKeyboard = "hideKeyboard"
    case setBackgroundColor = "setBackgroundColor"
    case setTopAreaColor = "setTopAreaColor"
    case setBottomAreaColor = "setBottomAreaColor"
    case versionCheck = "versionCheck"
    case openBrowser = "openBrowser"
    case refreshAble = "refreshAble"
    case swipeAble = "swipeAble"
    case uploadData = "uploadData"
    case saveUser = "saveUser"
    
    case scanNFC = "scanNFC"
    case beaconControl = "beaconControl"

    case devTest = "devTest"
}
