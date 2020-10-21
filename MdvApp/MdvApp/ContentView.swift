//
//  ContentView.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-10-21.
//

import UIKit
import SwiftUI

struct AnnouncementsView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    func makeUIViewController(context: Context) -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "AnnouncementsNavViewController")
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Doesn't matter for now
    }
}


struct ContentView: View {
    @State var isShowingSplashView = false

    var announcementsTab: some View {
        AnnouncementsView()
            .tabItem {
                Image(systemName: "airplane.circle.fill")
                    .imageScale(.large)
                Text("Sample")
            }
    }

    var calendarTab: some View {
        Text("Hello World")
            .tabItem {
                Image(systemName: "airplane.circle.fill")
                    .imageScale(.large)
                Text("Sample")
            }
    }

    var studentIdTab: some View {
        Text("Hello World")
            .tabItem {
                Image(systemName: "airplane.circle.fill")
                    .imageScale(.large)
                Text("Sample")
            }
    }

    var schoolMapTab: some View {
        Text("Hello World")
            .tabItem {
                Image(systemName: "airplane.circle.fill")
                    .imageScale(.large)
                Text("Sample")
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
                }
                .animation(Animation.easeInOut.speed(0.5))
                .transition(.move(edge: .bottom))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
