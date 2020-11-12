//
//  NotificationManager.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-10-16.
//

import Foundation
import UserNotifications
import CloudKit
import UIKit

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
                DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
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
    
    extension NotificationManager: UNUserNotificationCenterDelegate {
        
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler(.banner)
        }
        
    }
