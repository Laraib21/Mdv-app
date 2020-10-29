//
//  MdvApp.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-10-26.
//

import SwiftUI
@main
struct MdvApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    NotificationManager.shared.getUserPermission(success: print("Success"), failure: { print("Failed") })
                }
        }
    }
}
