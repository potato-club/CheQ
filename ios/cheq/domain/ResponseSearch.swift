//
//  ResponseSearch.swift
//  cheq
//
//  Created by Isaac Jang on 4/15/24.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let responseSearch = try? JSONDecoder().decode(ResponseSearch.self, from: jsonData)

import Foundation

// MARK: - ResponseSearch
struct ResponseSearch: Codable {
    let dsSreg: [SearchResultModel]

    enum CodingKeys: String, CodingKey {
        case dsSreg = "DS_SREG"
    }
}

// MARK: - DsSreg
struct SearchResultModel: Codable {
    let gudnJobNm: String?
    let dangDv: String?
    let rtshPldt, natnNm: String?
    let mlsvDv: String?
    let natvSchlGrduDt, sbmjOrgnzNo, sbmjOrgnzNm: String?
    let eschSemeDv: String?
    let interAplcDt, designOrgnzNm, designAplcDt: String?
    let lastloSregDv, gudnFaddr: String?
    let gudnTpnoDv, loFndv, bcarmDv, degreNmDv1: String?
    let degreNmDv2, grduYeiDt: String?
    let genDv: String?
    let degreCtfcNo1, cntrtEntprNm, degreCtfcNo2: String?
    let tpno: String?
    let conveAplcDt: String?
    let lastSregStNm: String?
    let lesnTryNm: String?
    let unvGrscDv: String?
    let grduGrno: String?
    let bfgdYn: Int?
    let shgr, rrno: String?
    let gudnDaddr, cossDv, interOrgnzNm, tcpfTpDv: String?
    let interOrgnzNo, tcstCERTNo: String?
    let regTmd: String?
    let sbmjAplcDt: String?
    let afflNm, genNm, natvDptmtNm: String?
    let eschTlntDv, gudnZpno: String?
    let eschDv: String?
    let regTms: Int?
    let eschDt, afflDv, dtlMajrOrgnzNo, grduYeiFg: String?
    let gudnTpno: String?
    let dspSbjtNm: String?
    let zpnoOrg, updtUserIP: String?
    let degreNmDvPot, slrdRmk: String?
    let eschCnt, userIdncNo, eschCntPyun, orgRrno: String?
    let bfgdSemeDv, grduDt: String?
    let zpno: String?
    let gofdNo, atshTrmyNm: String?
    let dtlMajrOrgnzNm: String?
    let scmjOrgnzNm1, scmjOrgnzNm2, gudnRlDv: String?
    let slrdCnt: Int?
    let eschNm: String?
    let natvUnivAdmtCrdt: Int?
    let egrdtYn: String?
    let degreCRSDv, rgsfDv: String?
    let natnDv: String?
    let cpnoOrg, regUserNo, chchFnm, addrOrg: String?
    let bfgdChk: String?
    let gudnAddr: String?
    let daddrOrg: String?
    let tcpfYn, chk: Int?
    let natvHschCD: String?
    let email, rgsfNm, wengFnm, frodiv: String?
    let dafDv: String?
    let semcntCnt: String?
    let updtTmd: String?
    let photo: String?
    let shgrDv: String?
    let admtSemeCnt: Int?
    let degreRegNo1, degreRegNo2: String?
    let contractSust, acadvEdpsNm, ststOrgnzNm: String?
    let dcasDt, degreNmDv: String?
    let vtrnYn: Int?
    let ststOrgnzNo, sregStDv, picApndFileIdncNo: String?
    let bfgdScyy: String?
    let natvUnivWengNm, majrOrgnzNm, sregFlctDt, tpnoOrg: String?
    let majrOrgnzNo: String?
    let bfgdDt: String?
    let acadvEdpsNo, sregStNm, stno: String?
    let conveOrgnzNm: String?
    let korFnm: String?
    let conveOrgnzNo: String?
    let grscOrgnzNm, eschScrnDv, lastSregStDv, shgrDvNm: String?
    let loaCntChk: Int?
    let grscOrgnzNo, faddr, regUserIP, eschYy: String?
    let degreCRSNmDvPot: String?
    let natvUnivSchlCD, dangNm: String?
    let gudnFnm: String?
    let rpsAuthCD: String?
    let degreCRSNmDv, degreNmDv1_Nm: String?
    let natvUnivNm: String?
    let entrWkplNm: String?
    let updtUserNo, udemNo: String?
    let natvUnivMjltp, scmjOrgnzNo1, scmjOrgnzNo2, natvHschNm: String?
    let daddr, dafNm: String?
    let scmjAplcDt1, scmjAplcDt2: String?
    let addr, cpno: String?
    let natvUnivGenrSlltp, natvUnivCtsbCrdt, natvShgrNm: String?

    enum CodingKeys: String, CodingKey {
        case gudnJobNm = "GUDN_JOB_NM"
        case dangDv = "DANG_DV"
        case rtshPldt = "RTSH_PLDT"
        case natnNm = "NATN_NM"
        case mlsvDv = "MLSV_DV"
        case natvSchlGrduDt = "NATV_SCHL_GRDU_DT"
        case sbmjOrgnzNo = "SBMJ_ORGNZ_NO"
        case sbmjOrgnzNm = "SBMJ_ORGNZ_NM"
        case eschSemeDv = "ESCH_SEME_DV"
        case interAplcDt = "INTER_APLC_DT"
        case designOrgnzNm = "DESIGN_ORGNZ_NM"
        case designAplcDt = "DESIGN_APLC_DT"
        case lastloSregDv = "LASTLO_SREG_DV"
        case gudnFaddr = "GUDN_FADDR"
        case gudnTpnoDv = "GUDN_TPNO_DV"
        case loFndv = "LO_FNDV"
        case bcarmDv = "BCARM_DV"
        case degreNmDv1 = "DEGRE_NM_DV_1"
        case degreNmDv2 = "DEGRE_NM_DV_2"
        case grduYeiDt = "GRDU_YEI_DT"
        case genDv = "GEN_DV"
        case degreCtfcNo1 = "DEGRE_CTFC_NO_1"
        case cntrtEntprNm = "CNTRT_ENTPR_NM"
        case degreCtfcNo2 = "DEGRE_CTFC_NO_2"
        case tpno = "TPNO"
        case conveAplcDt = "CONVE_APLC_DT"
        case lastSregStNm = "LAST_SREG_ST_NM"
        case lesnTryNm = "LESN_TRY_NM"
        case unvGrscDv = "UNV_GRSC_DV"
        case grduGrno = "GRDU_GRNO"
        case bfgdYn = "BFGD_YN"
        case shgr = "SHGR"
        case rrno = "RRNO"
        case gudnDaddr = "GUDN_DADDR"
        case cossDv = "COSS_DV"
        case interOrgnzNm = "INTER_ORGNZ_NM"
        case tcpfTpDv = "TCPF_TP_DV"
        case interOrgnzNo = "INTER_ORGNZ_NO"
        case tcstCERTNo = "TCST_CERT_NO"
        case regTmd = "REG_TMD"
        case sbmjAplcDt = "SBMJ_APLC_DT"
        case afflNm = "AFFL_NM"
        case genNm = "GEN_NM"
        case natvDptmtNm = "NATV_DPTMT_NM"
        case eschTlntDv = "ESCH_TLNT_DV"
        case gudnZpno = "GUDN_ZPNO"
        case eschDv = "ESCH_DV"
        case regTms = "REG_TMS"
        case eschDt = "ESCH_DT"
        case afflDv = "AFFL_DV"
        case dtlMajrOrgnzNo = "DTL_MAJR_ORGNZ_NO"
        case grduYeiFg = "GRDU_YEI_FG"
        case gudnTpno = "GUDN_TPNO"
        case dspSbjtNm = "DSP_SBJT_NM"
        case zpnoOrg = "ZPNO_ORG"
        case updtUserIP = "UPDT_USER_IP"
        case degreNmDvPot = "DEGRE_NM_DV_POT"
        case slrdRmk = "SLRD_RMK"
        case eschCnt = "ESCH_CNT"
        case userIdncNo = "USER_IDNC_NO"
        case eschCntPyun = "ESCH_CNT_PYUN"
        case orgRrno = "ORG_RRNO"
        case bfgdSemeDv = "BFGD_SEME_DV"
        case grduDt = "GRDU_DT"
        case zpno = "ZPNO"
        case gofdNo = "GOFD_NO"
        case atshTrmyNm = "ATSH_TRMY_NM"
        case dtlMajrOrgnzNm = "DTL_MAJR_ORGNZ_NM"
        case scmjOrgnzNm1 = "SCMJ_ORGNZ_NM_1"
        case scmjOrgnzNm2 = "SCMJ_ORGNZ_NM_2"
        case gudnRlDv = "GUDN_RL_DV"
        case slrdCnt = "SLRD_CNT"
        case eschNm = "ESCH_NM"
        case natvUnivAdmtCrdt = "NATV_UNIV_ADMT_CRDT"
        case egrdtYn = "EGRDT_YN"
        case degreCRSDv = "DEGRE_CRS_DV"
        case rgsfDv = "RGSF_DV"
        case natnDv = "NATN_DV"
        case cpnoOrg = "CPNO_ORG"
        case regUserNo = "REG_USER_NO"
        case chchFnm = "CHCH_FNM"
        case addrOrg = "ADDR_ORG"
        case bfgdChk = "BFGD_CHK"
        case gudnAddr = "GUDN_ADDR"
        case daddrOrg = "DADDR_ORG"
        case tcpfYn = "TCPF_YN"
        case chk = "CHK"
        case natvHschCD = "NATV_HSCH_CD"
        case email = "EMAIL"
        case rgsfNm = "RGSF_NM"
        case wengFnm = "WENG_FNM"
        case frodiv = "FRODIV"
        case dafDv = "DAF_DV"
        case semcntCnt = "SEMCNT_CNT"
        case updtTmd = "UPDT_TMD"
        case photo = "PHOTO"
        case shgrDv = "SHGR_DV"
        case admtSemeCnt = "ADMT_SEME_CNT"
        case degreRegNo1 = "DEGRE_REG_NO_1"
        case degreRegNo2 = "DEGRE_REG_NO_2"
        case contractSust = "CONTRACT_SUST"
        case acadvEdpsNm = "ACADV_EDPS_NM"
        case ststOrgnzNm = "STST_ORGNZ_NM"
        case dcasDt = "DCAS_DT"
        case degreNmDv = "DEGRE_NM_DV"
        case vtrnYn = "VTRN_YN"
        case ststOrgnzNo = "STST_ORGNZ_NO"
        case sregStDv = "SREG_ST_DV"
        case picApndFileIdncNo = "PIC_APND_FILE_IDNC_NO"
        case bfgdScyy = "BFGD_SCYY"
        case natvUnivWengNm = "NATV_UNIV_WENG_NM"
        case majrOrgnzNm = "MAJR_ORGNZ_NM"
        case sregFlctDt = "SREG_FLCT_DT"
        case tpnoOrg = "TPNO_ORG"
        case majrOrgnzNo = "MAJR_ORGNZ_NO"
        case bfgdDt = "BFGD_DT"
        case acadvEdpsNo = "ACADV_EDPS_NO"
        case sregStNm = "SREG_ST_NM"
        case stno = "STNO"
        case conveOrgnzNm = "CONVE_ORGNZ_NM"
        case korFnm = "KOR_FNM"
        case conveOrgnzNo = "CONVE_ORGNZ_NO"
        case grscOrgnzNm = "GRSC_ORGNZ_NM"
        case eschScrnDv = "ESCH_SCRN_DV"
        case lastSregStDv = "LAST_SREG_ST_DV"
        case shgrDvNm = "SHGR_DV_NM"
        case loaCntChk = "LOA_CNT_CHK"
        case grscOrgnzNo = "GRSC_ORGNZ_NO"
        case faddr = "FADDR"
        case regUserIP = "REG_USER_IP"
        case eschYy = "ESCH_YY"
        case degreCRSNmDvPot = "DEGRE_CRS_NM_DV_POT"
        case natvUnivSchlCD = "NATV_UNIV_SCHL_CD"
        case dangNm = "DANG_NM"
        case gudnFnm = "GUDN_FNM"
        case rpsAuthCD = "RPS_AUTH_CD"
        case degreCRSNmDv = "DEGRE_CRS_NM_DV"
        case degreNmDv1_Nm = "DEGRE_NM_DV_1_NM"
        case natvUnivNm = "NATV_UNIV_NM"
        case entrWkplNm = "ENTR_WKPL_NM"
        case updtUserNo = "UPDT_USER_NO"
        case udemNo = "UDEM_NO"
        case natvUnivMjltp = "NATV_UNIV_MJLTP"
        case scmjOrgnzNo1 = "SCMJ_ORGNZ_NO_1"
        case scmjOrgnzNo2 = "SCMJ_ORGNZ_NO_2"
        case natvHschNm = "NATV_HSCH_NM"
        case daddr = "DADDR"
        case dafNm = "DAF_NM"
        case scmjAplcDt1 = "SCMJ_APLC_DT_1"
        case scmjAplcDt2 = "SCMJ_APLC_DT_2"
        case addr = "ADDR"
        case cpno = "CPNO"
        case natvUnivGenrSlltp = "NATV_UNIV_GENR_SLLTP"
        case natvUnivCtsbCrdt = "NATV_UNIV_CTSB_CRDT"
        case natvShgrNm = "NATV_SHGR_NM"
    }
}
