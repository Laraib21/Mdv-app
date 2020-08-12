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
    // MARK: - IBOutlets
    @IBOutlet var containerViewController: UIView!
    @IBOutlet weak var calendarView: FSCalendar!

    // MARK: - Properties
    let eventsDirectory = EventsDirectory()
    let hostingController = UIHostingController(rootView: CalendarDetailView(events: []))

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(hostingController, intoContainer: containerViewController)
    }

    // MARK: - IBActions
    @IBAction func addEvent(_ sender: Any) {
        let event = EventPopup(dismiss: dismissHostingController)
         present(event)
    }

    // MARK: - Helper Functions
    func dismissHostingController(newEvent: Event) -> Void {
        eventsDirectory.addEvents(newEvent)
        let selectedDate = calendarView.selectedDate
        presentedViewController?.dismiss(animated: true){[weak self] in
            self?.calendarView.reloadData()
            let events: [Event]
            if let selectedDate = selectedDate {
                events = self?.eventsDirectory.events(on: selectedDate) ?? []
            } else {
                events = []
            }
            self?.hostingController.rootView = CalendarDetailView(events: events)
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
        hostingController.rootView = CalendarDetailView(events: eventsDirectory.events(on: date))
    }
}
