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
                    Text("Start")
                }
                DatePicker(selection: $end, displayedComponents: [.date, .hourAndMinute]) {
                    Text("End")
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
                TextEditor(text: $description)
                    .overlay(invalidEntryView($isDescriptionValid))
                    .frame(minHeight: 240)
            }
            .navigationBarTitle("New Event")
            .navigationBarItems(trailing: saveButton)

        }
    }
    let calendar = Calendar.autoupdatingCurrent
    func SaveEvent () {
        // TODO: Validate none of the fields are empty. If any are, don't dismiss!
        // NOTES:
        //    SwiftUI lets you use statements like this:
        isDescriptionValid = !description.isEmpty
        isTitleValid = !title.isEmpty

        endDateValid = end.timeIntervalSince(start) > 0
        
        let alertDate: Date?
        switch selection {
        case .atTimeOfEvent:
            alertDate = start
        case .thirtyMinutesBefore:
            alertDate = calendar.date(byAdding: .minute, value: -30,to: start) ?? start
        case .oneHourBefore:
            alertDate = calendar.date(byAdding: .hour, value: -1,to: start) ?? start
        case .oneDayBefore:
            alertDate = calendar.date(byAdding: .day, value: -1,to: start) ?? start
        case .twoDaysBefore:
            alertDate = calendar.date(byAdding: .day, value: -2,to: start) ?? start
        case .oneWeekBefore:
            alertDate = calendar.date(byAdding: .day, value: -7,to: start) ?? start
        case .noAlert:
            alertDate = nil
        default:
            alertDate = start
        }
        alertDateValid = (alertDate?.timeIntervalSince(Date()) ?? 61) > 60
        
        guard isTitleValid && isDescriptionValid && endDateValid else { return }
        
        let newEvent = Event(title: title, body: description, startDate: start, endDate: end, alertDate: alertDate)
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
        EventPopup()
    }
}


