//
//  CalendarViewController.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import Foundation
import UIKit
import FSCalendar
import SwiftUI

class CalendarViewController : UIViewController {
    
}

extension CalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 1
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let calendarDetailView = CalendarDetailView(events: ["event1", "event2", "event3"])
        present(calendarDetailView)
    }
}

extension UIViewController {
    func present<V: View>(_ view: V) {
         let hostingController = UIHostingController(rootView: view)
         present(hostingController, animated: true, completion: nil)
    }
}


let eventList = [String]()
