//
//  ResponseLogin.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//
//   let responseLogin = try? JSONDecoder().decode(ResponseLogin.self, from: jsonData)

import Foundation

// MARK: - ResponseLogin
struct ResponseLogin: Codable {
    let metadata: Metadata

    enum CodingKeys: String, CodingKey {
        case metadata = "_METADATA_"
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let uri: String
    let success: Bool
}
