//
//  addingAnnouncementView.swift
//  MdvApp
//
//  Created by School on 2020-09-17.
//

import SwiftUI

struct NewAnnouncementView: View {
    @State var title = ""
    @State var description = ""
    @State var isTitleValid = true
    @State var isDescriptionValid = true
    var dismiss: ((Announcement) -> Void)?
    var saveButton: some View {
        Button(action: saveAnnouncement) {
            Text("Save")
        }
    }
    
    @State private var isEditing = false
    @State private var isValid = true
    func saveAnnouncement () {
        let createAnnouncement = Announcement(title: title, body: description)
        self.dismiss?(createAnnouncement)
    }
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
                Section {
                    TextField("Announcement Title", text: $title)
                        .overlay(invalidEntryView($isTitleValid))
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
                .navigationBarItems(trailing: saveButton)
            }
        }
        
        
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    struct NewAnnouncementView_Previews: PreviewProvider {
        static var previews: some View {
            NewAnnouncementView()
        }
    }
    
}

