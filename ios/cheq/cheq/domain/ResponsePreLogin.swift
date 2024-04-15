//
//  ResponsePreLogin.swift
//  cheq
//
//  Created by Isaac Jang on 4/12/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let responsePreLogin = try? JSONDecoder().decode(ResponsePreLogin.self, from: jsonData)

import Foundation

// MARK: - ResponsePreLogin
struct ResponsePreLogin: Codable {
    let xidedu: Xidedu
    let sTime: String
    let result: [SSIDResult]?
}

// MARK: - Result
struct SSIDResult: Codable {
    let sugangStudentID: String

    enum CodingKeys: String, CodingKey {
        case sugangStudentID = "sugang_student_id"
    }
}

// MARK: - Xidedu
struct Xidedu: Codable {
    let pos, xmsg: String
    let mcount: JSONNull?
    let alpha: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
