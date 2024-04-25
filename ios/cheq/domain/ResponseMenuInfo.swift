//
//  ResponseMenuInfo.swift
//  cheq
//
//  Created by Isaac Jang on 4/16/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let responseMenuInfo = try? JSONDecoder().decode(ResponseMenuInfo.self, from: jsonData)

import Foundation

// MARK: - ResponseMenuInfo
struct ResponseMenuInfo: Codable {
    let errmsginfo: Errmsginfo?
    let dmMenuInfo: DmMenuInfo?
    
    enum CodingKeys: String, CodingKey {
        case errmsginfo = "ERRMSGINFO"
        case dmMenuInfo = "dmMenuInfo"
    }
}

// MARK: - DmMenuInfo
struct DmMenuInfo: Codable {
    let roleCtrlVar05: String?
    let menuKey, unitSysRcd, pgmFileNm: String?
    let topMenuID: String?
    let ctrlVar01, menuID: String?
    let ctrlVar02: String?
    let deptAuthRcd, roleCtrlVar01, roleCtrlVar02, menuNm: String?
    let roleCtrlVar03: String?
    let callPage: String?
    let roleCtrlVar04: String?
    let menuCD, upMenuID: String?
    let deputyLoginYn: String?
    let pgmID: String?
    let ctrlVar04: String?
    let useAuthRcd: String?

    enum CodingKeys: String, CodingKey {
        case roleCtrlVar05 = "ROLE_CTRL_VAR_05"
        case menuKey = "MENU_KEY"
        case unitSysRcd = "UNIT_SYS_RCD"
        case pgmFileNm = "PGM_FILE_NM"
        case topMenuID = "TOP_MENU_ID"
        case ctrlVar01 = "CTRL_VAR_01"
        case menuID = "MENU_ID"
        case ctrlVar02 = "CTRL_VAR_02"
        case deptAuthRcd = "DEPT_AUTH_RCD"
        case roleCtrlVar01 = "ROLE_CTRL_VAR_01"
        case roleCtrlVar02 = "ROLE_CTRL_VAR_02"
        case menuNm = "MENU_NM"
        case roleCtrlVar03 = "ROLE_CTRL_VAR_03"
        case callPage = "CALL_PAGE"
        case roleCtrlVar04 = "ROLE_CTRL_VAR_04"
        case menuCD = "MENU_CD"
        case upMenuID = "UP_MENU_ID"
        case deputyLoginYn = "DEPUTY_LOGIN_YN"
        case pgmID = "PGM_ID"
        case ctrlVar04 = "CTRL_VAR_04"
        case useAuthRcd = "USE_AUTH_RCD"
    }
}
