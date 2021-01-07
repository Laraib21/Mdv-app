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
    @State private var isShowingWelcome = false
    @State private var isShowingAppSignature = false
    
    @Binding var isShowing: Bool
    var welcomeOverlayView: some View{
        HStack {
            Spacer()
            Image("Welcome to Meadowvale Secondary School").resizable().aspectRatio(contentMode: .fit)
            Spacer()
        }
    }
    var overlayView: some View{
        VStack{
            HStack {
                if isShowingLets {
                    Image("LET’S")
                } else {
                    Spacer().frame(width: 70, height: 10)
                }
                if isShowingGO {
                    Image("Ellipse")
                    Image("GO")
                } else {
                    Spacer().frame(width: 80, height: 10)
                    
                }
                if isShowingFalcons {
                    Image("Ellipse")
                    Image("FALCONS")
                } else {
                    Spacer().frame(width: 183, height: 10)
                }
            }
            .transition(.opacity)
            Spacer()
            if isShowingLogo{
                Image("logo1").resizable().frame(width: 300, height: 295).aspectRatio(contentMode: .fit
                ).transition(.opacity)
            } else {
                Spacer().frame(width: 300, height: 295)
            }
            Spacer()
            if isShowingWelcome {
                Rectangle()
                    .stroke(lineWidth:2.5)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .overlay(welcomeOverlayView)
                    .padding()
                    .transition(.opacity)
            } else {
                Spacer().frame(width: 10, height: 82)
            }
            if isShowingAppSignature{
                Text("A Laraib Iqbal App")
                    .foregroundColor(.white)
                    .font(.caption2)
            } else {
                Spacer().frame(width: 10, height: 22)
            }
            
        }
        
        
        .onAppear {
            animationDispatch(deadline: .now() + 0.5, action: self.isShowingLets = true)
            
            animationDispatch(deadline: .now() + 1.0, action: self.isShowingGO = true)
            
            animationDispatch(deadline: .now() + 1.5, action: self.isShowingFalcons = true)
            
            animationDispatch(deadline: .now() + 2.0, action: self.isShowingLogo = true)
            
            animationDispatch(deadline: .now() + 2.5, action: self.isShowingWelcome = true)
            
            animationDispatch(deadline: .now() + 3.2, action: self.isShowingAppSignature = true)
            
            animationDispatch(deadline: .now() + 3.5, action: self.isShowing = false)
            
        }
    }
    var body: some View {
        RadialGradient(gradient: Gradient(colors: [
                                            Color(hexValue: "#0c58ce")!,
                                            Color(hexValue: "#0b1bfc")!]),
                       center: .init(x: 0.5, y: 0.8),
                       startRadius: 5,
                       endRadius: 500)
            .edgesIgnoringSafeArea(.all)
            .overlay(overlayView)
    }
    func animationDispatch(deadline: DispatchTime, action: @escaping @autoclosure () -> Void ){
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            withAnimation { action() }
        }

    }
}

struct LoadingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreenView(isShowing: .constant(true))
            .previewDevice("iPhone 11 Pro")
    }
}



