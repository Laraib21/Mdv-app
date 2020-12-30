//
//  ContentView.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-10-21.
//

import UIKit
import SwiftUI

struct CalendarView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    func makeUIViewController(context: Context) -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "CalendarNavViewController")
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Doesn't matter for now
    }
}

struct StudentIDView: UIViewControllerRepresentable {
    typealias UIViewControllerType = StudentIDViewController
    func makeUIViewController(context: Context) -> StudentIDViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "StudentIDViewController")
    }

    func updateUIViewController(_ uiViewController: StudentIDViewController, context: Context) {
        // Doesn't matter for now
    }
}

struct SchoolMapView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    func makeUIViewController(context: Context) -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "MapNavViewController")
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Doesn't matter for now
    }
}

struct ContentView: View {
    @State var isShowingSplashView = true
    @EnvironmentObject var announcementLoader: AnnouncementLoader

    var announcementsTab: some View {
        AnnouncementsTableView()
            .tabItem {
                Image(systemName: "hifispeaker")
                    .imageScale(.large)
                Text("Announcements")
            }
            .environmentObject(announcementLoader)
            .onAppear {
                NotificationManager.shared.getUserPermission(success: print("Success"),
                                                             failure: { print("Failed") })
            }
    }

    var calendarTab: some View {
        CalendarView()
            .tabItem {
                Image(systemName: "calendar.circle.fill")
                    .imageScale(.large)
                Text("Calendar")
            }
    }

    var studentIdTab: some View {
        StudentIDView()
            .tabItem {
                Image(systemName: "person.crop.square")
                    .imageScale(.large)
                Text("Student ID")
            }
    }

    var schoolMapTab: some View {
        SchoolMapView()
            .tabItem {
                Image(systemName: "map")
                    .imageScale(.large)
                Text("School Map")
            }
    }
    
    var newSchoolMapTab: some View {
        newMap()
            .tabItem {
                Image(systemName: "map")
                    .imageScale(.large)
                Text("New School Map")
            }
    }

    var body: some View {
        VStack {
            if isShowingSplashView {
                LoadingScreenView(isShowing: $isShowingSplashView)
            } else {
                TabView {
                    announcementsTab
                    calendarTab
                    studentIdTab
                    schoolMapTab
                    newSchoolMapTab
                }
                //.animation(Animation.easeInOut.speed(0.5))
                //.transition(.move(edge: .bottom))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State private static var announcementLoader = AnnouncementLoader()
    static var previews: some View {
        ContentView()
            .environmentObject(announcementLoader)
    }
}
