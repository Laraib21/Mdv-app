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
        VStack {
        Text(announcement.title)
            .padding(.vertical, 2)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(announcement.body)
                .font(.body)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
}

struct AnnouncementsTableView_Previews: PreviewProvider {
    static let shortSampleAnnouncement = Announcement(title: "November 18",
                                                      body: "Testing 123")
    static let longSampleAnnouncement = Announcement(title: "November 18 (2)",
                                                     body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at nisl diam. Quisque diam augue, viverra interdum scelerisque in, condimentum molestie nibh. Cras varius nec nunc quis laoreet. Sed eget semper ante, sit amet placerat eros. Nam finibus nulla quam, vel semper felis fringilla vitae. Integer eu semper leo, id convallis odio. Sed congue luctus purus eu laoreet. Suspendisse potenti. Nam leo lectus, placerat vel lorem non, tincidunt fringilla dolor. Pellentesque sit amet mi id neque ullamcorper semper in quis dui. Mauris dapibus facilisis felis nec sagittis. Curabitur condimentum gravida tortor vitae ullamcorper. Cras nec felis euismod, placerat enim eu, malesuada metus. Vivamus porta quis ipsum a consectetur. Cras suscipit fermentum nunc ac elementum.")
    static var previews: some View {
        Group {
            AnnouncementView(announcement: shortSampleAnnouncement)
            AnnouncementView(announcement: longSampleAnnouncement)
        }
        .previewLayout(.sizeThatFits)
    }
}

