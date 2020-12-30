//
//  newMap.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-12-29.
//

import SwiftUI

struct newMap: View {
    @State var scaleNumber: CGFloat = 0.5
    var body: some View {
        ScrollView{
            
            Image("3d full map (1)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                
                .scaleEffect(scaleNumber)
                .gesture(MagnificationGesture().onChanged({ (scale) in
                    print(scale)
                    scaleNumber = scale
                }))
        }
    }
}

struct newMap_Previews: PreviewProvider {
    static var previews: some View {
        newMap()
    }
}
