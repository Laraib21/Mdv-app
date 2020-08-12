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
    @IBAction func addEvent(_ sender: Any) {
        let event = EventPopup(dismiss: dismissHostingController)
         present(event)
    }
    @IBOutlet weak var calendarView: FSCalendar!
    
    let eventsDirectory = EventsDirectory()
    
    func dismissHostingController(newEvent: Event) -> Void {
        eventsDirectory.addEvents(newEvent)
        presentedViewController?.dismiss(animated: true){[weak self] in
            self?.calendarView.reloadData()
        }
    }

}
extension CalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return eventsDirectory.events(on: date).count
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let calendarDetailView = CalendarDetailView(events: eventsDirectory.events(on: date))
        present(calendarDetailView)
    }
}

extension UIViewController {
    func present<V: View>(_ view: V) {
         let hostingController = UIHostingController(rootView: view)
         present(hostingController, animated: true, completion: nil)
    }
}

struct CalendarDetailView: View {
    let events : [Event]
    var body: some View {
        List(events,id: \.self) { event in
            Text(event.title)
        }
    }
    var startDate: Date
    var endDate: Date
}




