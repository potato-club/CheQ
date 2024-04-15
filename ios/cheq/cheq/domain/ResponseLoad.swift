//
//  ResponseLoad.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//
//   let responseLoad = try? JSONDecoder().decode(ResponseLoad.self, from: jsonData)

import Foundation

// MARK: - ResponseLoad
struct ResponseLoad: Codable {
    let dmGlobalConfig: DmGlobalConfig?
    let dmUserInfo: DmUserInfo?
    let dsAllMenu, dsFirstLoadYn: [Ds]?
}

// MARK: - DmGlobalConfig
struct DmGlobalConfig: Codable {
    let mdiWindowMaxCount: String?
    let defaultLocale: String?
    let deputyLoginYn: String?
    let mdiAutoTabCloseYn, useSearchBoxClear: MDIAutoTabCloseYn?
    let userViewPartPopOut: String?
}

enum MDIAutoTabCloseYn: String, Codable {
    case n = "N"
}

// MARK: - DmUserInfo
struct DmUserInfo: Codable {
    let mPwd, //encrypt value
        telNo, // phone
        gUnvGrscDv, // ?? 검색시 필요한 param
        userID: String? // id
    let gUserNm: String? // name
    let userDiv: UserDiv? // ??
    let gUserNo, // 학번
        gRpsAuthCD, // ??
        email, // 이메일
        lang: String? // 언어
    let sysMgrYn: MDIAutoTabCloseYn?
    let mLoginID, cpno, lLoginDt, lLoginIP: String?
    let pgmMngrYn: MDIAutoTabCloseYn?
    let gBurDv, dupPermitYn: String?

    enum CodingKeys: String, CodingKey {
        case mPwd = "M_PWD"
        case telNo = "TEL_NO"
        case gUnvGrscDv = "G_UNV_GRSC_DV"
        case userID = "USER_ID"
        case gUserNm = "G_USER_NM"
        case userDiv = "USER_DIV"
        case gUserNo = "G_USER_NO"
        case gRpsAuthCD = "G_RPS_AUTH_CD"
        case email = "EMAIL"
        case lang = "LANG"
        case sysMgrYn = "SYS_MGR_YN"
        case mLoginID = "M_LOGIN_ID"
        case cpno = "CPNO"
        case lLoginDt = "L_LOGIN_DT"
        case lLoginIP = "L_LOGIN_IP"
        case pgmMngrYn = "PGM_MNGR_YN"
        case gBurDv = "G_BUR_DV"
        case dupPermitYn = "DUP_PERMIT_YN"
    }
}

enum UserDiv: String, Codable {
    case univ1 = "UNIV_1"
}

// MARK: - Ds
struct Ds: Codable {
    let pgmTypeRcd: PgmTypeRcd?
    let trvPval: TrvPval?
    let unitSysRcd: UnitSysRcd?
    let pgmFileNm, menuID: String?
    let upMenuID: UpMenuID?
    let deputyLoginYn, menuURL: String?
    let pgmID: String?
    let oprtRoleID: UserDiv?
    let icon: String?
    let trvVal: String?
    let useAuthRcd: UseAuthRcd?
    let menuLvl: Int?
    let roleCtrlVar05: String?
    let menuKey: String?
    let ctrlVar01: String?
    let ctrlVar02: String?
    let deptAuthRcd: DeptAuthRcd?
    let ctrlVar03: String?
    let roleCtrlVar01, roleCtrlVar02: MDIAutoTabCloseYn?
    let roleCtrlVar03: String?
    let menuNm: String?
    let roleCtrlVar04: String?
    let callPage: String?
    let menuCD: String?
    let firstLoadYn: String?
    let ctrlVar04, ctrlVar05: String?
    let pgmNm: String?
    let upPgmID: UpPgmID?
    let prtOrd: Int?

    enum CodingKeys: String, CodingKey {
        case pgmTypeRcd = "PGM_TYPE_RCD"
        case trvPval = "trv_pval"
        case unitSysRcd = "UNIT_SYS_RCD"
        case pgmFileNm = "PGM_FILE_NM"
        case menuID = "MENU_ID"
        case upMenuID = "UP_MENU_ID"
        case deputyLoginYn = "DEPUTY_LOGIN_YN"
        case menuURL = "MENU_URL"
        case pgmID = "PGM_ID"
        case oprtRoleID = "OPRT_ROLE_ID"
        case icon = "ICON"
        case trvVal = "trv_val"
        case useAuthRcd = "USE_AUTH_RCD"
        case menuLvl = "MENU_LVL"
        case roleCtrlVar05 = "ROLE_CTRL_VAR_05"
        case menuKey = "MENU_KEY"
        case ctrlVar01 = "CTRL_VAR_01"
        case ctrlVar02 = "CTRL_VAR_02"
        case deptAuthRcd = "DEPT_AUTH_RCD"
        case ctrlVar03 = "CTRL_VAR_03"
        case roleCtrlVar01 = "ROLE_CTRL_VAR_01"
        case roleCtrlVar02 = "ROLE_CTRL_VAR_02"
        case roleCtrlVar03 = "ROLE_CTRL_VAR_03"
        case menuNm = "MENU_NM"
        case roleCtrlVar04 = "ROLE_CTRL_VAR_04"
        case callPage = "CALL_PAGE"
        case menuCD = "MENU_CD"
        case firstLoadYn = "FIRST_LOAD_YN"
        case ctrlVar04 = "CTRL_VAR_04"
        case ctrlVar05 = "CTRL_VAR_05"
        case pgmNm = "PGM_NM"
        case upPgmID = "UP_PGM_ID"
        case prtOrd = "PRT_ORD"
    }
}

enum DeptAuthRcd: String, Codable {
    case cmn0350004 = "CMN035.0004"
}

enum PgmTypeRcd: String, Codable {
    case cmn06001 = "CMN060.01"
    case cmn06002 = "CMN060.02"
}

enum TrvPval: String, Codable {
    case std040010Menuheader = "STD040010;MENUHEADER"
    case std040020Menuheader = "STD040020;MENUHEADER"
    case std040030Menuheader = "STD040030;MENUHEADER"
    case std040040Menuheader = "STD040040;MENUHEADER"
    case std040050Menuheader = "STD040050;MENUHEADER"
    case std040060Menuheader = "STD040060;MENUHEADER"
    case std040070Menuheader = "STD040070;MENUHEADER"
    case the00020Menuheader = "00020;MENUHEADER"
    case the00040Menuheader = "00040;MENUHEADER"
    case the00041Menuheader = "00041;MENUHEADER"
}

enum UnitSysRcd: String, Codable {
    case cmn003Csd = "CMN003.CSD"
    case cmn003Mob = "CMN003.MOB"
}

enum UpMenuID: String, Codable {
    case std040010 = "STD040010"
    case std040020 = "STD040020"
    case std040030 = "STD040030"
    case std040040 = "STD040040"
    case std040050 = "STD040050"
    case std040060 = "STD040060"
    case std040070 = "STD040070"
    case the00020 = "00020"
    case the00040 = "00040"
    case the00041 = "00041"
}

enum UpPgmID: String, Codable {
    case menuheader = "MENUHEADER"
}

enum UseAuthRcd: String, Codable {
    case cmn0450001 = "CMN045.0001"
}
