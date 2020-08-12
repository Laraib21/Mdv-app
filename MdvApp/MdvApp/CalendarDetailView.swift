//
//  CalendarDetailView.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import SwiftUI

struct CalendarDetailView: View {
    let events : [Event]
    var body: some View {
        List(events,id: \.self) { event in
            Text(event.title)
        }
    }
}

struct CalendarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDetailView(events: ["event1", "event2", "event3"])
    }
}

