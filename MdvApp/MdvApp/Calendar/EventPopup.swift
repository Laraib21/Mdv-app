//
//  EventPopup.swift
//  MdvApp
//
//  Created by School on 2020-07-20.
//

import SwiftUI
typealias ReminderSelection = Int
extension ReminderSelection {
    static let atTimeOfEvent = 0
    static let thirtyMinutesBefore = 1
    static let oneHourBefore = 2
    static let oneDayBefore = 3
    static let twoDaysBefore = 4
    static let oneWeekBefore = 5
    static let noAlert = 6
}

struct NoShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path()
    }
}

struct EventPopup: View {
    @ObservedObject var event: Event
    @State var isTitleValid = true
    @State var isDescriptionValid = true
    @State var endDateValid = true
    @State var alertDateValid = true
    let isEditing: Bool

            
    
    var dismiss: ((Event) -> Void)?
    var saveButton: some View {
        Button(action: SaveEvent) {
            Text("Save")
        }
    }
    
    @State private var isValid = true
    
    func invalidEntryView(_ isValid: Binding<Bool>, colour: Color = .red) -> some View {
        VStack(alignment: .trailing) {
            if isValid.wrappedValue {
                EmptyView()
            } else {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .padding([.top], 2)
                            .foregroundColor(colour)
                    }
                    Spacer()
                }
            }
        }
    }
    
    var body: some View{
        NavigationView {
            Form {
                TextField("Title", text: $event.title)
                    .overlay(invalidEntryView($isTitleValid))
                DatePicker(selection: $event.startDate, displayedComponents: [.date, .hourAndMinute]) {
                    Text("Start").layoutPriority(1)
                }
                .disabled(event.allDay)
                DatePicker(selection: $event.endDate, displayedComponents: [.date, .hourAndMinute]) {
                    Text("End").layoutPriority(1)
                }
                .overlay(invalidEntryView($endDateValid))
                .disabled(event.allDay)
                
                Toggle(isOn: $event.allDay) {
                    Text("All Day")
                }
                .onChange(of: event.allDay) { (value) in
                    if value == true {
                        event.startDate = Calendar.autoupdatingCurrent.startOfDay(for: event.startDate)
                        event.endDate = Calendar.autoupdatingCurrent.date(bySettingHour: 23, minute: 59, second: 59, of: event.startDate) ?? event.startDate
                    } else {
                        event.startDate = Date()
                        event.endDate = Date(timeIntervalSinceNow: 1*60*60)
                    }
                }
                
                Picker(selection: $event.selection, label:
                        Text("Alert")
                       , content: {
                        Text("At time of event").tag(0)
                        Text("30 minutes before").tag(1)
                        Text("1 hour before").tag(2)
                        Text("1 day before").tag(3)
                        Text("2 days before").tag(4)
                        Text("1 week before").tag(5)
                        Text("No alert").tag(6)
                       })
                    .overlay(invalidEntryView($alertDateValid, colour: .yellow))
                ZStack(alignment: .leading){
                    TextEditor(text: $event.body)
                        .overlay(invalidEntryView($isDescriptionValid))
                        .frame(minHeight: 240)
                    if event.body.isEmpty {
                        VStack {
                            Text("Please enter description").foregroundColor(Color.gray.opacity(0.4)).padding(.top, 8).padding(.leading, 3).contentShape(NoShape())
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle(isEditing ? "Edit Event" : "New Event")
            .navigationBarItems(trailing: saveButton)
        }
    }
    func SaveEvent () {
        // TODO: Validate none of the fields are empty. If any are, don't dismiss!
        // NOTES:
        //    SwiftUI lets you use statements like this:
        isDescriptionValid = !event.body.isEmpty
        isTitleValid = !event.title.isEmpty
        
        endDateValid = event.endDate.timeIntervalSince(event.startDate) > 0
        

        
        alertDateValid = (event.alertDate?.timeIntervalSince(Date()) ?? 61) > 60
        
        guard isTitleValid && isDescriptionValid && endDateValid else { return }
        
        self.dismiss?(event)
        
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - showing the event below the calendar
struct EventPopup_Previews: PreviewProvider {
    @ObservedObject static var event = Event()
    static var previews: some View {
        EventPopup(event: event, isEditing: true)
    }
}



