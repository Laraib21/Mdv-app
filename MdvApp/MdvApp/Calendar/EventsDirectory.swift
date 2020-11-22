//
//  EventsDirectory.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import Foundation
import UserNotifications
import os.log
import SwiftUI

final class Event: Hashable, Codable, ObservableObject {
    enum CodingKeys: String, CodingKey {
        case title, body, startDate, selection, endDate
    }
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.title == rhs.title && lhs.body == rhs.body && lhs.startDate.timeIntervalSince1970 == rhs.startDate.timeIntervalSince1970 && lhs.endDate.timeIntervalSince1970 == rhs.endDate.timeIntervalSince1970
    }
    
    @Published var title: String
    @Published var body: String
    @Published var  startDate : Date
    @Published var selection: Int
    @Published var endDate: Date
    var alertDate: Date?{
        switch selection {
        case .atTimeOfEvent:
            return startDate
        case .thirtyMinutesBefore:
            return Calendar.autoupdatingCurrent.date(byAdding: .minute, value: -30,to: startDate) ?? startDate
        case .oneHourBefore:
            return Calendar.autoupdatingCurrent.date(byAdding: .hour, value: -1,to: startDate) ?? startDate
        case .oneDayBefore:
            return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1,to: startDate) ?? startDate
        case .twoDaysBefore:
            return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -2,to: startDate) ?? startDate
        case .oneWeekBefore:
            return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -7,to: startDate) ?? startDate
        case .noAlert:
            return nil
        default:
            return startDate
        }
    }
    let identifier = UUID()
    var spanMultipleDays: Bool {
        return true
    }

    init(title: String = "",
         body: String = "",
         startDate: Date = Date(),
         endDate: Date = Date(timeIntervalSinceNow: 1*60*60),
         selection: Int = 0) {
        self.title = title
        self.body = body
        self.startDate = startDate
        self.endDate = endDate
        self.selection = selection
    }
}

extension Event{
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let body = try container.decode(String.self, forKey: .body)
        let startDate = try container.decode(Date.self, forKey: .startDate)
        let endDate = try container.decode(Date.self, forKey: .endDate)
        let selection = try container.decode(Int.self, forKey: .selection)

        self.init(title: title,
                  body: body,
                  startDate: startDate,
                  endDate: endDate,
                  selection: selection)
    }
}

extension Event {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(selection, forKey: .selection)
    }
}

extension Event {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(body)
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(selection)
    }
}
// MARK: - shows events body, start and end date
extension Event: ExpressibleByStringLiteral {
    convenience init(stringLiteral value: String) {
        self.init(title: value)
    }
}

// MARK: - List of events
class EventsDirectory: NSObject, UNUserNotificationCenterDelegate {
    var events: [Event] = []
    let eventsUrl = URL.documentsDirectory.appendingPathComponent("events.txt")
    lazy var calendar = Calendar.autoupdatingCurrent
    
    
    func addEvents(_ event: Event){
        updatedEventsList(event)
        NotificationManager.shared.center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                self.scheduleNotification(for: event)
            case .denied:
                // Show an UIAlert
                print("Check settings for notification setup")
            case .notDetermined:
                NotificationManager.shared.getUserPermission(success: self.scheduleNotification(for: event), failure: { print("D'Oh") })
            @unknown default:
                print("Unhandled auth type: \(settings.authorizationStatus)")
            }
        }
    }
    
    // MARK: - shows event on the date that user identified
    func events(on date: Date) -> [Event] {
        return events.filter {
            calendar.isDate($0.startDate, inSameDayAs: date) ||
                calendar.isDate($0.endDate, inSameDayAs: date) ||
                (date.timeIntervalSince($0.startDate) >= 0 && date.timeIntervalSince($0.endDate) <= 0)
        }
    }
    
    // MARK: - Notification Center
    func getUserPermission(success: @escaping @autoclosure () -> Void, failure: @escaping () -> Void) {
        NotificationManager.shared.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
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
        
        let request = UNNotificationRequest(identifier: event.identifier.uuidString, content: content, trigger: trigger)
        NotificationManager.shared.center.add(request)
    }
    
    func registerCategories() {
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        NotificationManager.shared.center.setNotificationCategories([category])
    }
    
    
    // MARK: - saving user events to file
    func updatedEventsList(_ event: Event) {
        if events.contains(event) {
            removeNotification(for: event)
        } else {
            events.append(event)
        }
        save()
    }
    
    func save() {
        let encoded: Data
        do {
            encoded = try JSONEncoder().encode(events) // We should save _all_ of the events, not just the new one
            try encoded.write(to: eventsUrl, options: [.atomic])
        } catch {
            print("Encountered error: \(error)")
        }
    }
    
    func loadEvents(completion: @escaping(Error?) -> Void) {
        do {
            let encoded = try Data(contentsOf: eventsUrl)
            events = try JSONDecoder().decode([Event].self, from: encoded)
            os_log("Events loaded successfully", log: .default, type: .error)
            completion(nil)
        } catch {
            print("Encountered error: \(error)")
            os_log("User %{public}@ ecountered", log: .default, type: .error, error.localizedDescription)
            completion(error)
        }
    }
    
    func delete(event: Event, completion: @escaping() -> Void) {
        if let eventIndex = events.firstIndex(where: {$0.identifier == event.identifier}) {
            let removedEvent = events.remove(at: eventIndex)
            removeNotification(for: removedEvent)
            save()
        }
        completion()
    }
    
    func removeNotification(for event: Event) {
        NotificationManager.shared.center.getPendingNotificationRequests { requests in
            let requestsToBeRemoved = requests.filter { $0.identifier == event.identifier.uuidString }.map { $0.identifier }
            NotificationManager.shared.center.removePendingNotificationRequests(withIdentifiers: requestsToBeRemoved)
        }
    }
    
    
    
    
    
    
    
    
    
}
