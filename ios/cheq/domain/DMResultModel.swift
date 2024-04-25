//
//  DMResultModel.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//

import Foundation
// MARK: - DmChkAuthResult
struct DMResultModel: Codable {
    let returnCode, returnMessage: String
    
    var status: String? = nil// ResponseUserStatus
    
    var tidExpired: String? = nil // ResponsePushNoti
    var tid: String? = nil // ResponsePushNoti
}
