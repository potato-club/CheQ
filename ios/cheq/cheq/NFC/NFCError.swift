//
//  NFCError.swift
//  cheq
//
//  Created by Isaac Jang on 4/9/24.
//

import Foundation

public enum NFCError: Error {
    case unavailable
    case notSupported
    case readOnly
    case invalidPayloadSize
    case invalidated(errorDescription: String)
}
