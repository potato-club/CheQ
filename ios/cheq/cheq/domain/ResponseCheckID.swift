//
//  ResponseCheckID.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//

import Foundation

// MARK: - ResponseCheckID
struct ResponseCheckID: Codable {
    let errmsginfo: Errmsginfo?
    let dmCheckID: DmCheckID?

    enum CodingKeys: String, CodingKey {
        case errmsginfo = "ERRMSGINFO"
        case dmCheckID = "dmCheckId"
    }
}

// MARK: - DmCheckID
struct DmCheckID: Codable {
    let strIDYn: String

    enum CodingKeys: String, CodingKey {
        case strIDYn = "strIdYn"
    }
}

// MARK: - Errmsginfo
struct Errmsginfo: Codable {
    let errmsg: String
    let statuscode: Int
    let errcode: String

    enum CodingKeys: String, CodingKey {
        case errmsg = "ERRMSG"
        case statuscode = "STATUSCODE"
        case errcode = "ERRCODE"
    }
}

/**
 {
     "dmUserStatus": {
         "returnCode": "0000",
         "returnMessage": "요청이 정상 처리되었습니다.",
         "status": "1"
     }
 }

 {
     "dmUserStatus": {
         "returnCode": "1401",
         "returnMessage": "등록된 사용자가 없습니다.",
         "status": ""
     }
 }
 */
