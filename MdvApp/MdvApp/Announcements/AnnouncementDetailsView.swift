//
//  AnnouncementDetailsView.swift
//  MdvApp
//
//  Created by School on 2020-06-18.
//

import SwiftUI
struct AnnouncementDetailsView: View {
    let announcement: Announcement
    private let gradient = Gradient(colors: [Color(#colorLiteral(red: 0.003449816722, green: 0.0759826526, blue: 0.4911656976, alpha: 1)), Color(#colorLiteral(red: 0.008099403232, green: 0.1319192946, blue: 0.7244079709, alpha: 1))])
    var body: some View {
        ScrollView {
            AnnouncementView(announcement: announcement, maxCharacters: nil)
                .padding()
            //EmptyView()
        }
        .background(RadialGradient(gradient: gradient,
                                   center: .center,
                                   startRadius: 50,
                                   endRadius: 200).edgesIgnoringSafeArea(.all))
    }
}
struct AnnouncementDetailsView_Previews: PreviewProvider {
    static let announcement = Announcement(id: nil, title: "Title", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu augue metus. Donec ultrices pharetra libero eu ultrices. Aenean posuere convallis nisl, quis varius nunc congue in. Suspendisse consectetur, velit nec pretium bibendum, ligula sapien iaculis enim, sit amet porttitor leo lacus ac nisl. Sed sodales ante sed pretium auctor. Morbi ut vestibulum lorem. Sed lobortis vel ipsum quis rhoncus. Phasellus tempor mollis vestibulum. Nullam vel lacus in velit volutpat sagittis. Donec eu turpis eu ex auctor gravida id vitae nulla. Vestibulum laoreet lorem rutrum tortor congue, eget elementum turpis congue.\nFusce fringilla ante ac tempus rhoncus. Duis sollicitudin massa at leo venenatis sodales. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis consectetur bibendum ex sed consectetur. Morbi id ex nisi. Praesent bibendum tortor sed risus tempus consequat sed sit amet est. Proin hendrerit dolor ac lacus auctor malesuada. Sed at justo ultrices, ornare massa id, scelerisque lorem.\nQuisque tincidunt consequat volutpat. Curabitur at metus magna. Nunc hendrerit feugiat urna at euismod. Duis lectus mi, dignissim ac egestas quis, porta eu ipsum. Praesent laoreet aliquet elit, ut venenatis ipsum luctus a. Duis vel accumsan justo, interdum imperdiet tortor. Nulla arcu augue, dapibus id convallis eu, rutrum vitae urna. Nulla pretium pellentesque tellus auctor pharetra.\nAenean tincidunt, nulla tempor pulvinar rhoncus, purus lacus feugiat tortor, sit amet accumsan felis massa in felis. Integer et aliquam eros, a volutpat ex. Integer auctor elementum blandit. Suspendisse eget cursus risus, non fermentum mi. In rutrum erat nec nisi tincidunt, eu imperdiet arcu molestie. Curabitur venenatis fermentum nulla sit amet congue. Praesent id metus tellus. Nullam at convallis quam, non auctor diam.", endDate: Date())
    static var previews: some View {
        AnnouncementDetailsView(announcement: announcement)
    }
}
