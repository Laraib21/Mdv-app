//
//  Entities.swift
//  MdvApp
//
//  Created by School on 2020-06-15.
//

import Foundation
import CloudKit

struct Announcement: Codable {
   var title: String
   var body: String
   var tags: [Tag] = []
   enum CodingKeys: String, CodingKey {
        case title
        case body
    }
}
extension Announcement {
    init(record: CKRecord) {
        self.init(title: record["title"] as! String, body: record["body"] as! String, tags:[])
    }
}
struct Tag {
    var name: String
}
