//
//  Preference.swift
//  cheq
//
//  Created by Isaac Jang on 4/11/24.
//

import Foundation
class Preference {

    public static let shared = Preference()

    public static let NIL = "null"
    //key list
//    public static let USER_UUID = "USER_UUID"
    public static let KEY_USER_ID = "KEY_USER_ID"
    public static let KEY_LAST_COOKIE = "KEY_LAST_COOKIE"
    public static let KEY_USER_INFO = "KEY_USER_INFO"
    public static let KEY_USER_PHOTO = "KEY_USER_PHOTO"
    
    public static let KEY_LAST_URL = "KEY_LAST_URL"


    public static let KEY_USER_UUID = "KEY_USER_UUID"
    public static let KEY_TOKEN = "KEY_TOKEN"
    
    public static let KEY_LOG = "KEY_LOG"

    init() {
    }

    private func saveUUID(value: String) {
        let defUser = UserDefaults.standard
        defUser.set(value, forKey: Preference.KEY_USER_UUID)
    }
    
    private func removeUUID() { // why??
        let defUser = UserDefaults.standard
        defUser.removeObject(forKey: Preference.KEY_USER_UUID)
    }
    
    @discardableResult
    private func initKEY() -> UserDefaults {
        let nUUID = UUID().uuidString
        
        let defUser = UserDefaults.standard
        if let uuid = defUser.string(forKey: Preference.KEY_USER_UUID), uuid.count == nUUID.count {
            defUserKEY = UserDefaults.init(suiteName: uuid)
            return defUserKEY!
        }
        
        saveUUID(value: nUUID)
        defUserKEY = UserDefaults.init(suiteName: nUUID)
        return defUserKEY!
    }

    var defUserKEY : UserDefaults? = nil

    public func save(value: String, key: String) {
        if defUserKEY == nil {
            initKEY()
        }
        defUserKEY!.set(value, forKey: key)
    }

    public func get(key: String) -> String {
        if defUserKEY == nil {
            initKEY()
        }
        return defUserKEY!.string(forKey: key) ?? Preference.NIL
    }

    public func isEmpty(key: String) -> Bool {
        if defUserKEY == nil {
            initKEY()
        }
        let val = defUserKEY!.string(forKey: key) ?? Preference.NIL
        return val == Preference.NIL
    }

    public func remove(key: String) {
        if defUserKEY == nil {
            initKEY()
        }
        defUserKEY!.removeObject(forKey: key)
    }
    

    @discardableResult
    func saveLastUserInfo(m: DMUserId?) -> Bool {
        guard let json = try? JSONEncoder().encode(m) else {
            DLog.p("fail Json")
            save(value: Preference.NIL, key: Preference.KEY_USER_INFO)
            return false
        }
        guard let result = String(data: json, encoding: .utf8) else {
            DLog.p("fail Result")
            save(value: Preference.NIL, key: Preference.KEY_USER_INFO)
            return false
        }
        save(value: result, key: Preference.KEY_USER_INFO)
        return true
    }
    
    func getLastUserInfo() -> DMUserId? {
        let json = get(key: Preference.KEY_USER_INFO)
        if let data = json.data(using: .utf8) {
            if let result = try? JSONDecoder().decode(DMUserId.self, from: data) as DMUserId {
                return result
            }
            else {
                DLog.p(json)
//                do {
//                    try! JSONDecoder().decode(DmUserInfo.self, from: data)
//                } catch {
//                    
//                    DLog.p(error)
//                }
                DLog.p("fail load 1")
            }
        }
        return nil
    }
    
//    public func insertLogRow(str: String) {
//        if defUserKEY == nil {
//            initKEY()
//        }
//        var log = "{\"array\":[]}"
//        if !isEmpty(key: Preference.KEY_LOG) {
//            log = get(key: Preference.KEY_LOG)
//        }
//        
//        if let data = log.data(using: .utf8) {
//            if var result = try? JSONDecoder().decode(LogModel.self, from: data) as LogModel {
//                result.array.append(str)
//                save(value: String(data: try! JSONEncoder().encode(result), encoding: .utf8) ?? "", key: Preference.KEY_LOG)
//            }
//        }
//        
//    }

//    func getLastLogin() -> UserInfo? {
//        let json = get(key: Preference.KEY_LAST_LOGIN)
//        if let data = json.data(using: .utf8) {
//            if let result = try? JSONDecoder().decode(UserInfo.self, from: data) as UserInfo {
//                return result
//            }
//            else {
//                DLOG.e("fail load 1")
//            }
//        }
//        return nil
//    }
//
//    @discardableResult
//    func saveLastLogin(m: UserInfo) -> Bool {
//        guard let json = try? JSONEncoder().encode(m) else {
//            DLOG.e("fail Json")
//            return false
//        }
//        guard let result = String(data: json, encoding: .utf8) else {
//            DLOG.e("fail Result")
//            return false
//        }
//        save(value: result, key: Preference.KEY_LAST_LOGIN)
//        return true
//    }
//
//    func removeLastLogin(m: UserInfo) {
//        defUserKEY!.removeObject(forKey: Preference.KEY_LAST_LOGIN)
//    }
//
//
//    func getLastArea() -> AreaInfo? {
//        let json = get(key: Preference.KEY_LAST_AREA)
//        if let data = json.data(using: .utf8) {
//            if let result = try? JSONDecoder().decode(AreaInfo.self, from: data) as AreaInfo {
//                return result
//            }
//            else {
//                DLOG.e("fail load area")
//            }
//        }
//        return nil
//    }
//
//    @discardableResult
//    func saveLastArea(m: AreaInfo) -> Bool {
//        guard let json = try? JSONEncoder().encode(m) else {
//            DLOG.e("fail Json")
//            return false
//        }
//        guard let result = String(data: json, encoding: .utf8) else {
//            DLOG.e("fail Result")
//            return false
//        }
//        save(value: result, key: Preference.KEY_LAST_AREA)
//        return true
//    }`


}
