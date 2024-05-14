//
//  DataSession.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//

import Foundation


class DataSession {
    public static let shared = DataSession()

    private var _userInfo: DMUserId? = nil
    var userInfo: DMUserId? {
        get {
            if _userInfo == nil &&
                !Preference.shared.isEmpty(key: Preference.KEY_USER_INFO) {
                self._userInfo = Preference.shared.getLastUserInfo()
            }
            return self._userInfo
        }
        set(newVal) {
            Preference.shared.saveLastUserInfo(m: newVal)
            self._userInfo = newVal
        }
    }
    
    private var _lastCookie : String = Preference.NIL
    var lastCookie : String  {
        get {
            if _lastCookie == Preference.NIL &&
                !Preference.shared.isEmpty(key: Preference.KEY_LAST_COOKIE) {
                self._lastCookie = Preference.shared.get(key: Preference.KEY_LAST_COOKIE)
            }
            return self._lastCookie
        }
        set(newVal) {
            Preference.shared.save(value: newVal, key: Preference.KEY_LAST_COOKIE)
            self._lastCookie = newVal
        }
    }
    
    func isValidCookie() -> Bool {
        return lastCookie != Preference.NIL
    }
    
    

}
