//
//  AppIntent.swift
//  CheqDynamicWidget
//
//  Created by Isaac Jang on 6/11/24.
//

import WidgetKit
import AppIntents

@available(iOS 17, *)
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
