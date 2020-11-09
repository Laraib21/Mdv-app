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
    @State var start = Date()
    @State var end = Date()
    @State var title = ""
    @State var selection = 0
    @State var description = ""
    @State var isTitleValid = true
    @State var isDescriptionValid = true
    @State var endDateValid = true
    @State var alertDateValid = true
    let eventIdentifier: UUID?
    var dismiss: ((Event) -> Void)?
    var saveButton: some View {
        Button(action: SaveEvent) {
            Text("Save")
        }
    }
    
    @State private var isEditing = false
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
                TextField("Title", text: $title)
                    .overlay(invalidEntryView($isTitleValid))
                DatePicker(selection: $start, displayedComponents: [.date, .hourAndMinute]) {
                    Text("Start").layoutPriority(1)
                }
                DatePicker(selection: $end, displayedComponents: [.date, .hourAndMinute]) {
                    Text("End").layoutPriority(1)
                }
                .overlay(invalidEntryView($endDateValid))
                Picker(selection: $selection, label:
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
                    TextEditor(text: $description)
                        .overlay(invalidEntryView($isDescriptionValid))
                        .frame(minHeight: 240)
                    if description.isEmpty {
                        VStack {
                            Text("Please enter description").foregroundColor(Color.gray.opacity(0.4)).padding(.top, 8).padding(.leading, 3).contentShape(NoShape())
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle("New Event")
            .navigationBarItems(trailing: saveButton)
        }
    }
    func SaveEvent () {
        // TODO: Validate none of the fields are empty. If any are, don't dismiss!
        // NOTES:
        //    SwiftUI lets you use statements like this:
        isDescriptionValid = !description.isEmpty
        isTitleValid = !title.isEmpty
        
        endDateValid = end.timeIntervalSince(start) > 0
        
        let newEvent = Event(title: title, body: description, startDate: start, selection: selection, endDate: end, identifier: eventIdentifier)
        
        alertDateValid = (newEvent.alertDate?.timeIntervalSince(Date()) ?? 61) > 60
        
        guard isTitleValid && isDescriptionValid && endDateValid else { return }
        
        self.dismiss?(newEvent)
        
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - showing the event below the calendar
struct EventPopup_Previews: PreviewProvider {
    static var previews: some View {
        EventPopup(eventIdentifier: nil)
    }
}


