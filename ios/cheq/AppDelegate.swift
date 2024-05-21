//
//  AppDelegate.swift
//  cheq
//
//  Created by Isaac Jang on 4/9/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
            if(granted){
                print("user push permitted")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("user push not permitted")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self

        return true
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "cheq")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}




extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //포그라운드
        print("userNotificationCenter : willPresent")
        print("noti Come : \(notification.request.content.userInfo)")
        
        
//        guard let userInfo = notification.request.content.userInfo as? NSDictionary else {
        guard let userInfo = notification.request.content.userInfo as? NSDictionary else {
            DLog.p("return userInfo")
            completionHandler([.alert, .sound, .badge])
            return
        }
            
//        var aps = userInfo[AnyHashable("aps")] as! NSDictionary
//        var alert = aps["alert"] as! NSDictionary
        guard let strSeq = userInfo["roomSeq"] as? String, let roomSeq = Int(strSeq)  else {
            DLog.p("return roomSeq")
            completionHandler([.alert, .sound, .badge])
            return
        }
        
        guard let strType = userInfo["msgType"] as? String, let msgType = Int(strType)  else {
            DLog.p("return msgType")
            completionHandler([.alert, .sound, .badge])
            return
        }
        

//        if let rootViewController = window?.rootViewController as? MainNavVC {
//            if let viewController = rootViewController.viewControllers.last as? ChatCodeVC {
//                DLog.p("isSame = \(viewController.isSameSeq(seq: roomSeq))")
//                if viewController.isSameSeq(seq: roomSeq) {
//                    if msgType == 4 {
//                        viewController.showChatEndedDialog()
//                    }
//                    else {
//                        viewController.requestChatList(seq: roomSeq)
//                    }
//                    return
//                }
//            }
//            else if let viewController = rootViewController.viewControllers.last as? MainTabVC {
//                viewController.requestRoomList()
//                
//                
//                if let title : String = userInfo["title"] as? String, let body : String = userInfo["body"] as? String {
//                    if userInfo["local"] is String {
//                        completionHandler([.alert, .sound, .badge])
//                        return
//                    }
//                    
//                    completionHandler([])
//                    let content = UNMutableNotificationContent()
//
//                    content.title = title
//                    content.body = body
//                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "cushion_noti_30second.caf"))
//                    guard var sendingUserInfo = userInfo as? [AnyHashable : Any] else {
//                        completionHandler([])
//                        return
//                    }
//                    sendingUserInfo["local"] = "local"
//                    content.userInfo = sendingUserInfo as! [AnyHashable : Any]
//
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//                    let request = UNNotificationRequest(identifier: String(Date().timeIntervalSince1970),
//                                                        content: content,
//                                                        trigger: trigger)
//
//                    UNUserNotificationCenter.current().add(request) { error in
//                        if let error = error {
//                            print("Notification Error: ", error)
//                        }
//                    }
//                }
//                else {
//                    completionHandler([.alert, .sound, .badge])
//                }
//                
//                
//                return
//            }
//        }
        
        if msgType != 1 {
            DLog.p("return msgType \(msgType)")
            completionHandler([])
            return
        }
        
        

//        guard
//            let aps = userInfo["aps"] as? NSDictionary,
//            let alert = aps["alert"] as? NSDictionary,
//            let title = alert["title"] as? String,
//            let body = alert["body"] as? String
//        else {
//            DLog.p("error title body")
//            completionHandler([.alert, .sound, .badge])
//            return
//        }
////
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "cushion_noti_30second.caf"))
//        content.userInfo = userInfo as! [AnyHashable : Any]
////        content.badge = 1
//        let request = UNNotificationRequest(identifier: notification.request.identifier, content: content, trigger: notification.request.trigger)
//        let center = UNUserNotificationCenter.current()
//        center.add(request, withCompletionHandler: { (error) in
//            if error != nil {
//                DLog.p("local notification created successfully.")
//            }
//        })
        
        

        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void){
        let userInfo = response.notification.request.content.userInfo
        DLog.p("백그라운드 상태 userInfo= \(userInfo)")

//        var aps = userInfo[AnyHashable("aps")] as! NSDictionary
//        var alert = aps["alert"] as! NSDictionary
        guard let strSeq = userInfo["roomSeq"] as? String, let roomSeq = Int(strSeq)  else {
            DLog.p("return roomSeq")
            completionHandler()
            return
        }
        
//        if let rootViewController = window?.rootViewController as? MainNavVC {
//            if let viewController = rootViewController.viewControllers.last as? ChatCodeVC {
//                DLog.p("isSame = \(viewController.isSameSeq(seq: roomSeq))")
//                if viewController.isSameSeq(seq: roomSeq) {
//                    viewController.requestChatList(seq: roomSeq)
//                    return
//                }
//            }
//            rootViewController.initByRoomSeq(seq: roomSeq)
//        }
//        else {
//            let main = MainNavVC()
//            main.modalPresentationStyle = .fullScreen
//            if Preference.shared.isEmpty(key: Preference.KEY_USER_UUID) {
//                main.defView = LandingVC()
//            }
//            else {
//                SessionST.shared.userUuid = Preference.shared.get(key: Preference.KEY_USER_UUID)
//                DLog.p("user UUID : \(SessionST.shared.userUuid)")
//                main.defView = MainTabVC()
//            }
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = main
//            main.initByRoomSeq(seq: roomSeq)
//        }
        

        completionHandler()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        print(userInfo)
//        completionHandler(.newData)
        
        
//        var aps = userInfo[AnyHashable("aps")] as! NSDictionary
//        var alert = aps["alert"] as! NSDictionary
        guard let strSeq = userInfo["roomSeq"] as? String, let roomSeq = Int(strSeq)  else {
            print("return roomSeq")
            completionHandler(.newData)
            return
        }
        
        guard let strType = userInfo["msgType"] as? String, let msgType = Int(strType)  else {
            print("return msgType")
            completionHandler(.newData)
            return
        }
        
        
//        if msgType == 4 {
//            print("return msgType \(msgType)")
//            
//            if let rootViewController = window?.rootViewController as? MainNavVC {
//                if let viewController = rootViewController.viewControllers.last as? ChatCodeVC {
//                    DLog.p("isSame = \(viewController.isSameSeq(seq: roomSeq))")
//                    viewController.showChatEndedDialog()
//                    return
//                }
//                else if let viewController = rootViewController.viewControllers.last as? MainTabVC {
//                    viewController.requestRoomList()
//                }
//            }
//            
//            completionHandler(.failed)
//            
//            return
//        }
//        if msgType != 1 {
//            print("return msgType \(msgType)")
//            
//            completionHandler(.failed)
//            
//            return
//        }
        

        guard
            let title = userInfo["title"] as? String,
            let body = userInfo["body"] as? String
        else {
            DLog.p("error title body")
            completionHandler(.failed)
            return
        }
////
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "cushion_noti_30second.caf"))
//        content.userInfo = userInfo as! [AnyHashable : Any]
////        content.badge = 1
//        let request = UNNotificationRequest(identifier: Date().timeIntervalSince1970, content: content, trigger: <#UNNotificationTrigger?#>)
//        let center = UNUserNotificationCenter.current()
//        center.add(request, withCompletionHandler: { (error) in
//            if error != nil {
//                DLog.p("local notification created successfully.")
//            }
//        })
        
        let content = UNMutableNotificationContent()

        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "cushion_noti_30second.caf"))
        content.userInfo = userInfo as! [AnyHashable : Any]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: String(Date().timeIntervalSince1970),
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
 
    func printGeneric<T>(_ value: T) {
        let types = type(of: value)
        print("\(value) of type \(types)")
    }
}

//extension AppDelegate : MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        guard let fcmToken = fcmToken else { return }
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//        DLog.p("fcmToken : \(fcmToken)")
//        let savedFCMToken = Preference.shared.get(key: Preference.KEY_TOKEN)
//        if savedFCMToken != fcmToken {
//            UserDefaults.standard.set(fcmToken, forKey: "savedFCMToken")
//            UserDefaults.standard.synchronize()
//            // Update FCMToken to server by doing API call...
//            Preference.shared.save(value: fcmToken, key: Preference.KEY_TOKEN)
//        }
//
//    }
//
//    
//
//
////    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
////        print("Received data message: \(remoteMessage.appData)")
////        Messaging.messaging().shouldEstablishDirectChannel = true
////    }
//}
