//
//  Entities.swift
//  MdvApp
//
//  Created by School on 2020-06-15.
//

import Foundation
import CloudKit

struct Announcement: Identifiable {

    let id: CKRecord.ID?
    var title: String
    var body: String
    let endDate: Date
}
extension Announcement {
    init(record: CKRecord) {
        self.init(id: record.recordID ,title: record["title"] as! String,
                  body: record["body"] as! String, endDate: Date())
    }
}
struct Tag: Codable, Equatable, Hashable {
    var name: String
}
