//
//  Entities.swift
//  MdvApp
//
//  Created by School on 2020-06-15.
//

import Foundation

struct Announcement {
   var title: String
   var body: String
   var tags: [Tag]
}

struct Tag {
    var name: String
}

