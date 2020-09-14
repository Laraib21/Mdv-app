//
//  loadingScreenView.swift
//  MdvApp
//
//  Created by School on 2020-09-14.
//

import SwiftUI

struct LoadingScreenView: View {
    @State private var isShowingLets = false
    @State private var isShowingGO = false
    @State private var isShowingFalcons = false
    var overlayView: some View{
        VStack{
            HStack {
                if isShowingLets {
                    Image("loading-mdv_0004_LETS-")
                }
                if isShowingGO {
                    Image("loading-mdv_0001_Ellipse-1")
                    Image("loading-mdv_0003_GO")
                }
                if isShowingFalcons {
                    Image("loading-mdv_0001_Ellipse-1")
                    Image("loading-mdv_0002_FALCONS")
                }
            }
            .transition(.opacity)
            Spacer()
            //school logo goes here
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { self.isShowingLets = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation { self.isShowingGO = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation { self.isShowingFalcons = true }
            }
        }
    }
    var body: some View {
        Rectangle().foregroundColor(.blue).edgesIgnoringSafeArea(.all)
            .overlay(overlayView)
    }
}

struct LoadingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreenView()
    }
}


