//
//  CalendarDetailView.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import SwiftUI

struct CalendarDetailView: View {
    var events : [Event]
    var body: some View {
        List(events,id: \.self) { event in
            Text(event.title)
        }
    }
}

    // MARK: - sample list of events for calendar
struct CalendarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDetailView(events: ["event1", "event2", "event3"])
    
    
if events.isEmpty == true {
    VStack {
        Text("No Events Today")
    }
} else {
    VStack {
        List(...) {
            // ...
        }
    }
}

    
}
}
