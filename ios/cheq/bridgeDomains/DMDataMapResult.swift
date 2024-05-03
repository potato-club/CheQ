//
//  DMDataMapResult.swift
//  cheq
//
//  Created by Isaac Jang on 5/3/24.
//

import Foundation

struct DMDataMapResult : Codable {
    var result : BaseResultDomain
    var data : [String:String]
}
