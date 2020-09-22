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
    @State private var isShowingLogo = false

    var dismiss: (() -> Void)?

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
            if isShowingLogo{
                Image("loading-mdv_0007_Layer-2").transition(.opacity)
            }
            Spacer()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation { self.isShowingLogo = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation { self.dismiss?() }
            }
        }
    }
    var body: some View {
        RadialGradient(gradient: Gradient(colors: [
                                            Color(hexValue: "#000099")!,
                                            Color(hexValue: "#0000FF")!]),
                       center: .init(x: 0.5, y: 0.8),
                       startRadius: 5,
                       endRadius: 500)
            .edgesIgnoringSafeArea(.all)
            .overlay(overlayView)
    }
}

struct LoadingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreenView()
    }
}



