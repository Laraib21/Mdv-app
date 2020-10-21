//
//  ContentView.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-10-21.
//

import SwiftUI

struct ContentView: View {
    @State var isShowingSplashView = true
    var announcementsTab: some View{
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .tabItem {
                Image(systemName: "airplane.circle.fill")
                    .imageScale(.large)
                Text("Sample")
            }
    }
    var calendarTab: some View{
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .tabItem {
                Image(systemName: "airplane.circle.fill")
                    .imageScale(.large)
                Text("Sample")
            }
    }
    var studentIDTab: some View{
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .tabItem {
                Image(systemName: "airplane.circle.fill")
                    .imageScale(.large)
                Text("Sample")
            }
    }
    var schoolMapTab: some View{
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .tabItem {
                Image(systemName: "airplane.circle.fill")
                    .imageScale(.large)
                Text("Sample")
            }
    }
    var body: some View {
        VStack{
            if isShowingSplashView{
                LoadingScreenView(isShowing: $isShowingSplashView)
            } else{
                TabView{
                    announcementsTab
                    calendarTab
                    studentIDTab
                    schoolMapTab
                }.animation(Animation.easeInOut.speed(0.5))
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
