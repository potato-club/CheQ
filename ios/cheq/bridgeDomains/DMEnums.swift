//
//  DMEnums.swift
//  cheq
//
//  Created by Isaac Jang on 5/3/24.
//

import Foundation

enum UploadDataTypes {
    case deviceId
    case fcmToken
    
    var name: String {get { return String(describing: self).lowercased() }}
}
//enum OpenMediaTypes {
//    case camera
//    case gallery
//
//    var name: String {get { return String(describing: self).lowercased() }}
//}
//enum CameraTypes {
//    case ocr
//    case default500
//
//    var name: String {get { return String(describing: self).lowercased() }}
//}
//enum GalleryTypes {
//    case default500
//
//    var name: String {get { return String(describing: self).lowercased() }}
//}
//enum PermissionTypes {
//    case microphone
//    case gallery
//    case camera
//
//    var name: String {get { return String(describing: self).lowercased() }}
//}
enum Observers : CaseIterable{
    case WebLoad, DownloadFile

    var name: String {get { return String(describing: self).lowercased() }}
}
enum OnOffTypes : CaseIterable{
    case ON, OFF

    var name: String {get { return String(describing: self).lowercased() }}
}
