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
        calendarView.select(Date())
        addChildViewController(hostingController, intoContainer: containerViewController)
        
        eventsDirectory.loadEvents { [weak self]
            _ in
            self?.refreshEvent()
        }
    }
    
    // MARK: - IBActions
    @IBAction func addEvent(_ sender: Any) {
        let event = EventPopup(event:.constant(Event()), dismiss: saveDismissHostingController)
        present(event)
    }
    
    func createNotification(date: Date) {
        
    }
    
    // MARK: - Helper Functions
    func saveDismissHostingController(newEvent: Event) -> Void {
        eventsDirectory.addEvents(newEvent)
        presentedViewController?.dismiss(animated: true){[weak self] in
            self?.refreshEvent()
        }
    }
    
    func deleteDismissHostingController(existingEvent: Event) -> Void {
        eventsDirectory.delete(event: existingEvent) {[weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
            self?.refreshEvent()
        }
    }
    
    func refreshEvent() {
        calendarView.reloadData()
        let events: [Event]
        if let selectedDate = calendarView.selectedDate {
            events = eventsDirectory.events(on: selectedDate)
        } else {
            events = []
        }
        hostingController.rootView = CalendarDetailView(events: events, saveDismiss: saveDismissHostingController, deleteDismiss: deleteDismissHostingController)
    }
    
}
extension CalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return eventsDirectory.events(on: date).count
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let events = eventsDirectory.events(on: date)
        hostingController.rootView = CalendarDetailView(events: events, saveDismiss: saveDismissHostingController, deleteDismiss: deleteDismissHostingController )
    }
}


