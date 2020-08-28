//
//  dateExtensions.swift
//  MdvApp
//
//  Created by School on 2020-08-06.
//

import Foundation

extension Date {
    func fullDistance(from date: Date, resultIn components: Set<Calendar.Component>, calendar: Calendar = .current) -> DateComponents {
        calendar.dateComponents(components, from: self, to: date)
    }
    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}
