//
//  CheqDynamicWidgetBundle.swift
//  CheqDynamicWidget
//
//  Created by Isaac Jang on 6/11/24.
//

import WidgetKit
import SwiftUI

@main @available(iOS 17, *)
struct CheqDynamicWidgetBundle: WidgetBundle {
    var body: some Widget {
        CheqDynamicWidget()
        CheqDynamicWidgetLiveActivity()
    }
}
