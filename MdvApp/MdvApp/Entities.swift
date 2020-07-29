//
//  Entities.swift
//  MdvApp
//
//  Created by School on 2020-06-15.
//

import Foundation

struct Announcement: Codable {
   var title: String
   var body: String
   var tags: [Tag] = []
   enum CodingKeys: String, CodingKey {
        case title
        case body
    }
}

struct Tag {
    var name: String
}
