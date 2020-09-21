//
//  addingAnnouncementView.swift
//  MdvApp
//
//  Created by School on 2020-09-17.
//

import SwiftUI

struct addingAnnouncementView: View {
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
        Button(action: {}) {
            Text("Save Announcement")
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
                TextField("Announcement Title", text: $title)
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
                ZStack(alignment: .topLeading) {
                    MultilineTextView(text: $description, isEditing: $isEditing)
                        .frame(height: 200)
                        .overlay(invalidEntryView($isDescriptionValid))
                    if !isEditing && description.isEmpty {
                        Text("Enter some Announcement Details")
                            .contentShape(NoShape())
                            .foregroundColor(Color.gray.opacity(0.7))
                    }
                }
            }
            .navigationBarTitle("New Announcement")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

struct addingAnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        addingAnnouncementView()
    }
}

