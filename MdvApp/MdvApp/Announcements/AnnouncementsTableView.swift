//
//  AnnouncementsTableView.swift
//  MdvApp
//
//  Created by Terry Latanville on 2020-11-11.
//

import SwiftUI
import os.log

// TODO
// 1. Set blue background
// 2. Display announcement body and tags
// 3. Add announcement button action / view

struct AnnouncementsTableView: View {
    @EnvironmentObject var announcementsLoader: AnnouncementLoader
    @State private var selectedAnnouncement: Announcement?
    @State private var isShowingAnnouncement = false
    @State private var isShowingNewAnnouncement = false
    
    var addNewAnnouncementButton: some View {
        Button(action: { isShowingNewAnnouncement = true }) {
            Image(systemName: "plus")
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(announcementsLoader.announcements) { announcement in
                    AnnouncementView(announcement: announcement)
                        .onTapGesture {
                            selectedAnnouncement = announcement
                            isShowingAnnouncement = true
                        }
                }
            }
            .navigationTitle("Announcements")
            .navigationBarItems(trailing: addNewAnnouncementButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            announcementsLoader.updateSubscriptions()
            announcementsLoader.fetchAnnouncements { possibleError in
                if let possibleError = possibleError{
                    print(possibleError)
                    os_log("User encountered error: %{public}@", log: .default, type: .error, possibleError.localizedDescription)
                    return
                }
                os_log("Announcements loaded!", log: .default, type: .error)
            }
        }
        .sheet(isPresented: $isShowingAnnouncement, onDismiss: {
            selectedAnnouncement = nil
            isShowingAnnouncement = false
        }, content: {
            AnnouncementDetailsView(announcement: selectedAnnouncement!)
        })
        .sheet(isPresented: $isShowingNewAnnouncement) {
            NewAnnouncementView(dismiss:addNewAnnouncement(_:))
        }
    }
    
    func addNewAnnouncement(_ newAnnouncement: Announcement) {
            announcementsLoader.save(newAnnouncement) { possibleError in
                if let error = possibleError {
                    print("Encountered error saving announcement: \(error)")
                } else {
                    isShowingNewAnnouncement = false
                }
            }
        }
    
    
    
}

struct AnnouncementView: View {
    let announcement: Announcement
    var body: some View {
        Text(announcement.title)
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
    }
}

struct AnnouncementsTableView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsTableView()
    }
}
