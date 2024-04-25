//
//  ResponsePushNoti.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//

import Foundation
// MARK: - ResponsePushNoti
struct ResponsePushNoti: Codable {
    let dmPushNoti: DMResultModel
}


/**
 {
     "dmPushNoti": {
         "returnCode": "1401",
         "returnMessage": "알수 없는 오류가 발생했습니다."
     }
 }

 {
     "dmPushNoti": {
         "returnCode": "0000",
         "returnMessage": "인증요청이 완료되었습니다.",
         "tidExpired": "2024-04-15 04:56:54",
         "tid": "9B27B9E08E01000052505353203B985A"
     }
 }
 */
