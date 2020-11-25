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
    static let tags = "tags"
    static let useless = "useless"
}

class AnnouncementLoader: ObservableObject {
    static let shared = AnnouncementLoader()
    private init() {}
    let publicRecord = CKContainer(identifier: "iCloud.meadowvaleApp").publicCloudDatabase
    @Published var announcements: [Announcement] = []
    @Published var canCreateAnnouncementButton = false
    
    func applicationDidReceive(_ ckQueryNotification: CKQueryNotification, completion: @escaping(Bool) -> Void) {
        guard let checkTitle = ckQueryNotification.recordFields?["title"] as? String,
              let checkBody = ckQueryNotification.recordFields?["body"] as? String
        else {
            print("failed")
            completion(false)
            return
        }
        let announcementCreater = Announcement(id: ckQueryNotification.recordID, title: checkTitle, body: checkBody)
        DispatchQueue.main.async{
            withAnimation{
                print(announcementCreater)
                self.announcements.append(announcementCreater) }
        }
        completion(true)
    }
    
    // MARK: - gets announcements from the internet
    
    func fetchAnnouncements(completion: @escaping (Swift.Error?) -> Void) {
        let query = CKQuery(recordType: .announcement, predicate: NSPredicate(value: true))
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
        publicRecord.save(newRecord) { [weak self] (_, error) in
            if let possibleError = error {
                print(possibleError)
                self?.canCreateAnnouncementButton = false
            } else {
                self?.canCreateAnnouncementButton = true
            }
        }
    }
    
    
    func save(_ announcement: Announcement, completion: @escaping (Swift.Error?) -> Void) {
        let newRecord = CKRecord(recordType: .announcement)
        newRecord.setValue(announcement.title, forKey: .title)
        newRecord.setValue(announcement.body, forKey: .body)
        newRecord.setValue(announcement.tags.flatMap { $0.name }, forKey: .tags)
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
        //notification.alertBody = "show up."
        // notification.soundName = "default"
        notification.shouldSendContentAvailable = true
        notification.desiredKeys = ["title", "body"]
        
        subscription.notificationInfo = notification
        
        publicRecord.save(subscription) { _ , error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
}

struct AnnouncementLoaderKey: EnvironmentKey {
    static let defaultValue = AnnouncementLoader.shared
}
extension EnvironmentValues {
    var announcementloader: AnnouncementLoader {
        get { self[AnnouncementLoaderKey.self] }
        set { self[AnnouncementLoaderKey.self] = newValue }
    }
}
