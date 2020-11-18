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
                .onAppear {
                    NotificationManager.shared.getUserPermission(success: print("Success"), failure: { print("Failed") })
                }
                .environment(\.announcementloader, AnnouncementLoaderKey.defaultValue)
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let ckQueryNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) {
            AnnouncementLoader.shared.applicationDidReceive(ckQueryNotification) { success in
                if success {
                    completionHandler(.newData)
                } else {
                    completionHandler(.failed)
                }
            }
        } else {
            completionHandler(.noData)
        }
    }
}
