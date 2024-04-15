//
//  ResponseUserStatus.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//
//   let responseUserStatus = try? JSONDecoder().decode(ResponseUserStatus.self, from: jsonData)

import Foundation

// MARK: - ResponseUserStatus
struct ResponseUserStatus: Codable {
    let dmUserStatus: DMResultModel
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
