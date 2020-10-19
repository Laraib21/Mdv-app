//
//  NotificationManager.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-10-16.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    private override init() {}
    lazy var center: UNUserNotificationCenter = {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return center
    }()
    
    func getUserPermission(success: @escaping @autoclosure () -> Void, failure: @escaping () -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                self.registerCategories()
                success()
            } else {
                failure()
            }
        }
    }
    
    func registerCategories() {
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        NotificationManager.shared.center.setNotificationCategories([category])
    }
    
}
extension NotificationManager: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")
                break
                
            default:
                break
            }
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.banner)
    }
    
}
