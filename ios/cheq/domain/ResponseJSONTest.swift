//
//  ResponseJSONTest.swift
//  cheq
//
//  Created by Isaac Jang on 5/14/24.
//

import Foundation

// MARK: - ResponseJSONTest
struct ResponseJSONTest: Codable {
    let date: String?
    let millisecondsSinceEpoch: Int?
    let time: String?

    enum CodingKeys: String, CodingKey {
        case date
        case millisecondsSinceEpoch = "milliseconds_since_epoch"
        case time
    }
}
