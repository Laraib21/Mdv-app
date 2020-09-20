//
//  CalendarDetailView.swift
//  MdvApp
//
//  Created by School on 2020-07-15.
//

import SwiftUI

struct CalendarDetailView: View {
    var events : [Event]
    @State var showingDetail = false
    @State var currentEvent: Event? = nil
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
                    Text(event.title).onTapGesture {
                        self.currentEvent = event
                        self.showingDetail = true
                    }
                }
            }
        }.sheet(isPresented: $showingDetail) {
            CalendarEventDetailView(event: self.currentEvent!)
        
        }
    }
}
struct CalendarEventDetailView: View {
    let event: Event
    var body: some View {
        VStack {
            Text(event.title)
            Text(event.body)
        }
    }
    
}

    // MARK: - sample list of events for calendar
struct CalendarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDetailView(events: [])
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
