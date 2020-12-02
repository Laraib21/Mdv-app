//
//  announcementsLoader.swift
//  MdvApp
//
//  Created by School on 2020-07-02.
//

import Foundation
import Combine
import CloudKit
import SwiftUI

extension CKRecord.RecordType {
    static let announcement = "Announcement"
    static let SecurityAccess = "SecurityAccess"
}
typealias RecordKey = String
extension RecordKey {
    static let creationDate = "creationDate"
    static let title = "title"
    static let body = "body"
    static let endDate = "endDate"
    static let useless = "useless"
}

final class AnnouncementLoader: ObservableObject {
    init() {}
    
    let publicRecord = CKContainer(identifier: "iCloud.meadowvaleApp").publicCloudDatabase
    @Published var announcements: [Announcement] = []
    @Published var canCreateAnnouncementButton = false
    
    func applicationDidReceive(_ ckQueryNotification: CKQueryNotification, completion: @escaping(Bool) -> Void) {
        guard let checkTitle = ckQueryNotification.recordFields?["title"] as? String,
              let checkBody = ckQueryNotification.recordFields?["body"] as? String,
              let checkEndDate = ckQueryNotification.recordFields?["endDate"] as? Int
        else {
            print("failed")
            completion(false)
            return
        }
        let announcementCreater = Announcement(id: ckQueryNotification.recordID, title: checkTitle, body: checkBody, endDate: Date(timeIntervalSinceReferenceDate: TimeInterval(checkEndDate)))
        DispatchQueue.main.async{ [weak self] in
            withAnimation{
                print(announcementCreater)
                self?.announcements.append(announcementCreater) }
        }
        completion(true)
    }

    func applicationDidFakeAnnouncement() {
        let fakeNotification = CKQueryNotification(fromRemoteNotificationDictionary: [
            "ck": [
                "ckuserid": "_b5cec76afbce9515866a8b7e7a08482a",
                "ce": 2,
                "nid": "19afdb06-72cc-4286-85ee-b6b837353928",
                "cid": "iCloud.meadowvaleApp",
                "qry": [
                    "dbs": 2,
                    "zid": "_defaultZone",
                    "zoid": "_defaultOwner",
                    "rid": "93B69669-AF9B-4400-AE69-290A12083C5A",
                    "sid": "0FE54158-6974-4CFF-ACF5-1A06557337BA",
                    "fo": 1,
                    "af": [
                        "title": "November 28 (3)",
                        "body": "Testing 123"
                    ]
                ]
            ],
            "aps": [
                "content-available": 1
            ]
        ])!
        applicationDidReceive(fakeNotification, completion: { _ in })
    }
    
    // MARK: - gets announcements from the internet
    
    func fetchAnnouncements(completion: @escaping (Swift.Error?) -> Void) {
        let predicate = NSPredicate(format: "endDate > %@", NSDate())
        let query = CKQuery(recordType: .announcement, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: RecordKey.creationDate, ascending: false)]
        publicRecord.perform(query, inZoneWith: .default) { [weak self] records, error in
            DispatchQueue.main.async {
                self?.announcements = records?.map { Announcement(record: $0) } ?? []
                completion(error)
            }
        }
    }
    
    func saveSecurityAccess() {
        let newRecord = CKRecord(recordType: .SecurityAccess)
        newRecord.setValue("\(Date().timeIntervalSinceReferenceDate)", forKey: .useless)
        publicRecord.save(newRecord) { [weak self] _, error in
            if let possibleError = error {
                print(possibleError)
                DispatchQueue.main.async { self?.canCreateAnnouncementButton = false }
            } else {
                DispatchQueue.main.async { self?.canCreateAnnouncementButton = true }
            }
        }
    }
    
    
    func save(_ announcement: Announcement, completion: @escaping (Swift.Error?) -> Void) {
        let newRecord = CKRecord(recordType: .announcement)
        newRecord.setValue(announcement.title, forKey: .title)
        newRecord.setValue(announcement.body, forKey: .body)
        newRecord.setValue(announcement.endDate, forKey: .endDate)
        publicRecord.save(newRecord) { record, error in
            print("Saved \(String(describing: record))")
            DispatchQueue.main.async { completion(error) }
        }
    }
    
    
    func updateSubscriptions(){
        publicRecord.fetchAllSubscriptions { [weak self] subscriptions, error in
            if let possibleError = error{
                print(possibleError)
                return
            }


            subscriptions?.forEach {
                self?.publicRecord.delete(withSubscriptionID: $0.subscriptionID) { possibleResult, possibleError in
                    if let error = possibleError {
                        print("Encountered error deleting: \(error)")
                    } else if let result = possibleResult {
                        print("Delete result: \(result)")
                    } else {
                        print("Unsure what happened when deleting subscriptions.")
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.subscribeToAnnouncements()
            }
        }
    }
    
    func subscribeToAnnouncements() {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: .announcement, predicate: predicate, options: .firesOnRecordCreation)

        let notification = CKSubscription.NotificationInfo()
        notification.shouldSendContentAvailable = true
        notification.desiredKeys = ["title", "body", "endDate"]
        
        subscription.notificationInfo = notification

        publicRecord.save(subscription) { _ , error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
}
