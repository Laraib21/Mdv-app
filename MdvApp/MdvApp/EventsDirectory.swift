//
//  EventsDirectory.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import Foundation

struct Event {
    let title: String
    let body: String
    let startDate : Date
    let endDate: Date
}

class EventsDirectory {
    var events: [Event] = []
}
