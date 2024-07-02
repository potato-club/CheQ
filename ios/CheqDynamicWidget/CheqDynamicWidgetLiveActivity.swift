//
//  CheqDynamicWidgetLiveActivity.swift
//  CheqDynamicWidget
//
//  Created by Isaac Jang on 6/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

@available(iOS 17, *)
struct CheqDynamicWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var statusStr: String
    }
}

@available(iOS 17, *)
struct CheqDynamicWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CheqDynamicWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("\(context.state.statusStr)")
            }
            .activityBackgroundTint(Color.gray)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("\(context.state.statusStr)")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.statusStr)")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("\(context.state.statusStr)")
                    // more content
                }
            } compactLeading: {
                Text(context.state.statusStr)
            } compactTrailing: {
                Text(context.state.statusStr)
            } minimal: {
                Text(context.state.statusStr)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
}

@available(iOS 17, *)
extension CheqDynamicWidgetAttributes {
    fileprivate static var preview: CheqDynamicWidgetAttributes {
        CheqDynamicWidgetAttributes()
    }
}

@available(iOS 17, *)
extension CheqDynamicWidgetAttributes.ContentState {
     fileprivate static var initScanning: CheqDynamicWidgetAttributes.ContentState {
        CheqDynamicWidgetAttributes.ContentState(statusStr: "Scanning...")
     }
     
     fileprivate static var connected: CheqDynamicWidgetAttributes.ContentState {
         CheqDynamicWidgetAttributes.ContentState(statusStr: "Connected!")
     }
    
    fileprivate static var disconnected: CheqDynamicWidgetAttributes.ContentState {
        CheqDynamicWidgetAttributes.ContentState(statusStr: "dis-connected..")
    }
}



@available(iOS 17, *)
#Preview("Notification", as: .content, using: CheqDynamicWidgetAttributes.preview) {
   CheqDynamicWidgetLiveActivity()
} contentStates: {
    CheqDynamicWidgetAttributes.ContentState.initScanning
    CheqDynamicWidgetAttributes.ContentState.connected
    CheqDynamicWidgetAttributes.ContentState.disconnected
}
