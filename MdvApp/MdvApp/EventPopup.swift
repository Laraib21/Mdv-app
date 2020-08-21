        //
//  EventPopup.swift
//  MdvApp
//
//  Created by School on 2020-07-20.
//

import SwiftUI
    // MARK: - event configuration
        struct EventPopup: View {
            @State var start = Date()
            @State var end = Date()
            @State var title = ""
            @State var description = ""
            var dismiss: ((Event) -> Void)?
            var saveButton: some View {
                Button(action: SaveEvent) {
                    Text("Save")
                }
            }
            var body: some View{
                NavigationView {
                    Form {
                        TextField("Title", text: $title)
                        DatePicker(selection: $start, displayedComponents: [.date, .hourAndMinute]) {
                            Text("Start")
                        }
                        DatePicker(selection: $end, displayedComponents: [.date, .hourAndMinute]) {
                            Text("End")
                        }
                        TextField("Description of Event", text: $description)
                        .frame(height: 200)
                    }
                    .navigationBarItems(trailing: saveButton)
                    
                }
            }
    // MARK: - saving the event
            func SaveEvent () {
                /*
                let str = "Super long string here"
                let filename = getDocumentsDirectory().appendingPathComponent("output.txt")

                do {
                    try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                    print(error)
                }
                */
                let newEvent = Event(title: title, body: description, startDate: start, endDate: end)
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

        
