//
//  DLog.swift
//  cheq
//
//  Created by Isaac Jang on 4/11/24.
//

import Foundation

open class DLog {

    private static let TAG = "**JIS**"


    public static func p<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
        
        #if DEBUG
        let th = Thread.current.isMainThread ? "main": Thread.current.name ?? "-"
        var str = ""
        if let obj = object {
            str = "\(TAG) \(Date()) \(th) \(filename.components(separatedBy: "/").last ?? ""):\(line)) ::\(funcName)\n    **** \(obj)"
        } else {
            str = "\(TAG) \(Date()) \(th) \(filename.components(separatedBy: "/").last ?? ""):\(line)) ::\(funcName)"
        }
        
//        Preference.shared.insertLogRow(str: str.matchString())
        print(str)
        #endif
    }

}

extension String {
    // [정규식 수행 실시 : 사용 방법 : let changeData = strData.matchString(_string: strData)]
    func matchString () -> String { // 문자열 변경 실시
        let strArr = Array(self) // 문자열 한글자씩 확인을 위해 배열에 담는다
        
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9:]$" // 정규식 : 한글, 영어, 숫자만 허용 (공백, 특수문자 제거)
        //let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]$" // 정규식 : 한글, 영어, 숫자, 공백만 허용 (특수문자 제거)
        
        // 문자열 길이가 한개 이상인 경우만 패턴 검사 수행
        var resultString = ""
        if strArr.count > 0 {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                var index = 0
                while index < strArr.count { // string 문자 하나 마다 개별 정규식 체크
                    let checkString = regex.matches(in: String(strArr[index]), options: [], range: NSRange(location: 0, length: 1))
                    if checkString.count == 0 {
                        index += 1 // 정규식 패턴 외의 문자가 포함된 경우
                    }
                    else { // 정규식 포함 패턴의 문자
                        resultString += String(strArr[index]) // 리턴 문자열에 추가
                        index += 1
                    }
                }
            }
            return resultString
        }
        else {
            return self // 원본 문자 다시 리턴
        }
    }
}
