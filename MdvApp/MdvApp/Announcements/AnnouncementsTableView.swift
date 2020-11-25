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

private let gradient = Gradient(colors: [Color(#colorLiteral(red: 0.003449816722, green: 0.0759826526, blue: 0.4911656976, alpha: 1)), Color(#colorLiteral(red: 0.008099403232, green: 0.1319192946, blue: 0.7244079709, alpha: 1))])
struct AnnouncementsTableView: View {
    @EnvironmentObject var announcementsLoader: AnnouncementLoader
    @State private var isShowingNewAnnouncement = false
    
    var addNewAnnouncementButton: some View {
        VStack{
            if announcementsLoader.canCreateAnnouncementButton == true {
                Button(action: { isShowingNewAnnouncement = true }) {
                    Image(systemName: "plus")
                }
            } else {
                EmptyView()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer().frame(height: 22)
                ForEach(announcementsLoader.announcements) { announcement in
                    NavigationLink(
                        destination:             AnnouncementDetailsView(announcement: announcement),
                        label: {
                            AnnouncementView(announcement: announcement)
                                .padding()
                        })
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .background(RadialGradient(gradient: gradient,
                                       center: .center,
                                       startRadius: 50,
                                       endRadius: 200).edgesIgnoringSafeArea(.all))            .navigationTitle("Announcements")
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
            VStack {
                Text(announcement.title)
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 2)
                Text(announcement.body)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 2)
            }
            .padding(30)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(color: .black, radius: 12)
            Spacer()
                .frame(height: 20)
            Divider()
                .background(Color.white)
                .padding(.horizontal, 30)
        }
    }
}

struct AnnouncementsTableView_Previews: PreviewProvider {
    static let shortSampleAnnouncement = Announcement(id: nil, title: "November 18",
                                                      body: "Testing 123")
    static let longSampleAnnouncement = Announcement(id: nil, title: "November 18 (2)",
                                                     body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at nisl diam. Quisque diam augue, viverra interdum scelerisque in, condimentum molestie nibh. Cras varius nec nunc quis laoreet. Sed eget semper ante, sit amet placerat eros. Nam finibus nulla quam, vel semper felis fringilla vitae. Integer eu semper leo, id convallis odio. Sed congue luctus purus eu laoreet. Suspendisse potenti. Nam leo lectus, placerat vel lorem non, tincidunt fringilla dolor. Pellentesque sit amet mi id neque ullamcorper semper in quis dui. Mauris dapibus facilisis felis nec sagittis. Curabitur condimentum gravida tortor vitae ullamcorper. Cras nec felis euismod, placerat enim eu, malesuada metus. Vivamus porta quis ipsum a consectetur. Cras suscipit fermentum nunc ac elementum.")
    static var previews: some View {
        Group {
            AnnouncementView(announcement: shortSampleAnnouncement)
                .padding()
                .background(Color.blue)
            AnnouncementView(announcement: longSampleAnnouncement)
                .padding()
                .background(Color.blue)
        }
        .previewLayout(.sizeThatFits)
    }
}
