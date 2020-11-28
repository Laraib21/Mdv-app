//
//  MdvApp.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-10-26.
//

import CloudKit
import SwiftUI
@main
struct MdvApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.announcementLoader)
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    @ObservedObject var announcementLoader = AnnouncementLoader()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        announcementLoader.saveSecurityAccess()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("application(\(application), didRegisterForRemoteNotificationsWithDeviceToken: {PRIVATE})")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("application(\(application), didFailToRegisterForRemoteNotificationsWithError: \(error))")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let ckQueryNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) else {
            completionHandler(.noData)
            return
        }
        announcementLoader.applicationDidReceive(ckQueryNotification) { success in
            if success {
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }
    }
}
