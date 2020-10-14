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
                            .padding([.top], 1)
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
                    ZStack(alignment: .leading){
                        TextEditor(text: $description)
                            .frame(minHeight: 240)
                        if description.isEmpty {
                            VStack {
                                Text("Please enter description").foregroundColor(Color.gray.opacity(0.5)).padding(.top, 8).padding(.leading, 0.5).contentShape(NoShape())
                                Spacer()
                            }
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

