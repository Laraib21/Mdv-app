//
//  EventsDirectory.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import Foundation

struct Event: Hashable{
    let title: String
    let body: String
    let startDate : Date
    let endDate: Date
}
extension Event: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(title: value, body: "", startDate: Date(), endDate: Date())
    }
}
    
class EventsDirectory {
    var events: [Event] = []
    func addEvents(_ event: Event){
        events.append(event)
    }
    
   func events(on date: Date) -> [Event] {
        return events.filter { $0.startDate.hasSame(.day, as: date) }
    }
}
