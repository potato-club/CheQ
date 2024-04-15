//
//  DataSession.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//

import Foundation


class DataSession {
    public static let shared = DataSession()

    var userInfo: DmUserInfo? = nil
    var lastCookie : String? = nil

}
