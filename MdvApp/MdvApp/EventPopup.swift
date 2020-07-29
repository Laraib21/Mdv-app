        //
//  EventPopup.swift
//  MdvApp
//
//  Created by School on 2020-07-20.
//

import SwiftUI


         
        struct EventPopup: View {
            @State var start = Date()
            @State var end = Date()
            @State var title = ""
            var saveButton: some View {
                Button(action: SaveEvent) {
                    Text("Save")
                }
            }
            var body: some View{
                NavigationView {
                    Form {
                        TextField("Placeholder", text: $title)
                        DatePicker(selection: $start, displayedComponents: [.date, .hourAndMinute]) {
                            Text("Start")
                        }
                        DatePicker(selection: $end, displayedComponents: [.date, .hourAndMinute]) {
                            Text("End")
                        }
                    }
                    .navigationBarItems(trailing: saveButton)
                    
                }
            }
            func SaveEvent () {
                let str = "Super long string here"
                let filename = getDocumentsDirectory().appendingPathComponent("output.txt")

                do {
                    try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                    print(error)
                }
            }
            func getDocumentsDirectory() -> URL {
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                return paths[0]
            }
        }

struct EventPopup_Previews: PreviewProvider {
    static var previews: some View {
        EventPopup()
    }
}

        
