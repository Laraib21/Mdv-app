//
//  CalendarDetailView.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import SwiftUI

struct CalendarDetailView: View {
    var events : [Event]
    var saveDismiss: ((Event) -> Void)?
    var deleteDismiss: ((Event) -> Void)?
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
                    NavigationLink(event.title, destination: CalendarEventDetailView(event: .constant(event), saveDismiss: saveDismiss, deleteDismiss: deleteDismiss))
                }
            }
        }
    }
}
struct CalendarEventDetailView: View {
   @Binding var event: Event
    var saveDismiss: ((Event) -> Void)?
    var deleteDismiss: ((Event) -> Void)?
    @State var showingDetail = false
    @State private var showingDeleteAlert = false
    var editButton: some View {
        Button(action: {showingDetail = true}) {
            Text("Edit")
        }
    }
    var deleteButton: some View {
        Button(action: {showingDeleteAlert = true}) {
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
            Rectangle()
                .foregroundColor(Color(UIColor.systemGroupedBackground))
                .frame(height: 2)
        }.tabItem { Text("Calendar") }
        .navigationBarItems(trailing: editButton)
        .sheet(isPresented: $showingDetail){
            EventPopup(event: event, dismiss:saveDismiss)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Event?"), primaryButton: .destructive(Text("Yes"), action: {deleteDismiss? (event)}), secondaryButton: .cancel())
        }
    }
}

// MARK: - sample list of events for calendar
struct CalendarDetailView_Previews: PreviewProvider {
    @State static var event = Event(title: "My Test Event Title", body: "My Test Event Body")
    static var previews: some View {
        Group {
            CalendarDetailView(events: [])
            CalendarEventDetailView(event: $event)
        }
    }
}


