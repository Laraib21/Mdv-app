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
}

class AnnouncementLoader: ObservableObject {
    @Published var announcements: [Announcement] = [
        Announcement(title: "Welcome Back Meadowvale!", body:"Hello Falcons, welcome back after an unsual time. It's going to be hard but we will get through it together as we always do.Hello Falcons, welcome back after an unsual time. It's going to be hard but we will get through it together as we always do.Hello Falcons, welcome back after an unsual time. It's going to be hard but we will get through it together as we always do.Hello Falcons, welcome back after an unsual time. It's going to be hard but we will get through it together as we always do.", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
    ]
    
    // MARK: - gets announcements from the internet
    func announcmentGetter(completion: @escaping ([Announcement]) -> Void) {
        completion(announcements)
        /*
         let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
         
         let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
         guard let data = data else {
         print("Encountered error: \(error?.localizedDescription ?? "Unknown")")
         return
         }
         let announcements = try! JSONDecoder().decode([Announcement].self, from: data)
         DispatchQueue.main.async {
         completion(announcements)
         }
         }
         task.resume()
         
         }
         }
         */
    }
    func fetchAnnouncements(completion: @escaping (Swift.Error?) -> Void) {
        let query = CKQuery(recordType: .announcement, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: RecordKey.creationDate, ascending: false)]
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: .default) { [weak self] records, error in
            self?.announcements = records?.map { Announcement(record: $0) } ?? []
            completion(error)
        }
    }
}
