//
//  CalendarDetailView.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import SwiftUI

struct CalendarDetailView: View {
    var events : [Event]
    var dismiss: ((Event) -> Void)?
    var body: some View {
        VStack{
            if events.isEmpty{
                List{
                    Text("")
                    Text("")
                    Text("")
                    HStack {
                        Spacer()
                        Text("No Events")
                        Spacer()
                    }
                }
            } else {
                List(events,id: \.self) { event in
                    NavigationLink(event.title, destination: CalendarEventDetailView(event: event, dismiss: dismiss))
                }
            }
        }
    }
}
struct CalendarEventDetailView: View {
    let event: Event
    var dismiss: ((Event) -> Void)?
    @State var showingDetail = false
    var editButton: some View {
        Button(action: {showingDetail = true}) {
            Text("Edit")
        }
    }
    var deleteButton: some View {
        Button(action: {}) {
            Text("Delete")
        }
    }
    let timeFormatter: DateFormatter = {
        let myFormatter = DateFormatter()
        myFormatter.timeStyle = .short
        return myFormatter
    }()
    
    let dayFormatter: DateFormatter = {
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .medium
        return myFormatter
    }()
    var formattedStartTime: String {
        return timeFormatter.string(from: event.startDate)
    }
    var formattedEndTime: String {
        return timeFormatter.string(from: event.endDate)
    }
    var formattedStartDate: String {
        return dayFormatter.string(from: event.startDate)
    }
    var formattedEndDate: String {
        return dayFormatter.string(from: event.endDate)
    }
    var body: some View {
        VStack {
            Form {
                if event.spanMultipleDays {
                    VStack(alignment: .leading) {
                        Text("from \(formattedStartTime), \(formattedStartDate)")
                        Text("to \(formattedEndTime), \(formattedEndDate)")
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text(dayFormatter.string(from: event.startDate))
                        Text("from \(formattedStartTime) to  \(formattedEndTime)")
                    }
                }
                Text(event.body).frame(minHeight: 60)
                //Text(dateFormatter.string(from: event.startDate))
                // Text(dateFormatter.string(from: event.endDate))
            }
            deleteButton
        }.navigationBarTitle(event.title)
        .navigationBarItems(trailing: editButton)
        .sheet(isPresented: $showingDetail){
            EventPopup(start: event.startDate, end: event.endDate, title: event.title, selection:0, description: event.body, eventIdentifier: event.identifier, dismiss:dismiss)
        }
    }
}

// MARK: - sample list of events for calendar
struct CalendarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalendarDetailView(events: [])
            CalendarEventDetailView(event: Event(title: "My Test Event Title", body: "My Test Event Body", startDate: Date(), endDate: Date(), alertDate: Date()))
        }
    }
}


//if events.isEmpty == true {
//    VStack {
//        Text("No Events Today")
//    }
//} else {
//    VStack {
//        List(...) {
//            // ...
//        }
//    }
//}
