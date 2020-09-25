//
//  EventsDirectory.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import Foundation
import UserNotifications

struct Event: Hashable{
    let title: String
    let body: String
    let startDate : Date
    let endDate: Date
    let alertDate: Date?
    var spanMultipleDays: Bool {
        return false
    }
        // let alert:
}

// MARK: - shows events body, start and end date
extension Event: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(title: value, body: "", startDate: Date(), endDate: Date(), alertDate: Date())
    }
}

// MARK: - List of events
class EventsDirectory: NSObject, UNUserNotificationCenterDelegate {
    var events: [Event] = []

    lazy var calendar = Calendar.autoupdatingCurrent
    lazy var center: UNUserNotificationCenter = {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return center
    }()

    func addEvents(_ event: Event){
        events.append(event)
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                self.scheduleNotification(for: event)
            case .denied:
                // Show an UIAlert
                print("Check settings for notification setup")
            case .notDetermined:
                self.getUserPermission(success: self.scheduleNotification(for: event), failure: { print("D'Oh") })
            @unknown default:
                print("Unhandled auth type: \(settings.authorizationStatus)")
            }
        }
    }
    
    // MARK: - shows event on the date that user identified
    func events(on date: Date) -> [Event] {
        return events.filter { calendar.isDate($0.startDate, inSameDayAs: date) }
    }

    // MARK: - Notification Center
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

    func scheduleNotification(for event: Event) {
        guard let alertDate = event.alertDate else { return }
        let timeInterval = alertDate.timeIntervalSince(Date())
        guard timeInterval > 0 else {return}
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval ,repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.body = event.body
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategories() {
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }

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
