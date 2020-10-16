//
//  announcementsLoader.swift
//  MdvApp
//
//  Created by School on 2020-07-02.
//

import Foundation
import Combine
import CloudKit

extension CKRecord.RecordType {
    static let announcement = "Announcement"
}
typealias RecordKey = String
extension RecordKey {
    static let creationDate = "creationDate"
    static let title = "title"
    static let body = "body"
    static let tags = "tags"
}

class AnnouncementLoader: ObservableObject {
    let publicRecord = CKContainer(identifier: "iCloud.meadowvaleApp").publicCloudDatabase
    @Published var announcements: [Announcement] = []
    
    // MARK: - gets announcements from the internet
   
    func fetchAnnouncements(completion: @escaping (Swift.Error?) -> Void) {
        let query = CKQuery(recordType: .announcement, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: RecordKey.creationDate, ascending: false)]
        publicRecord.perform(query, inZoneWith: .default) { [weak self] records, error in
            self?.announcements = records?.map {Announcement(record: $0) } ?? []
            DispatchQueue.main.async { completion(error) }
        }
        subscriptions()
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
    
    
    func subscriptions(){
        publicRecord.fetchAllSubscriptions { [weak self] subscriptions, error in
            if let possibleError = error{
                print(possibleError)
                return
            }
            
            
            if let possibleSubscriptions = subscriptions, possibleSubscriptions.isEmpty{
                self?.subscribeToAnnouncements()
            }
            
        }
    }
    
    func subscribeToAnnouncements() {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: .announcement, predicate: predicate, options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "show up."
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        publicRecord.save(subscription) { _ , error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
}
