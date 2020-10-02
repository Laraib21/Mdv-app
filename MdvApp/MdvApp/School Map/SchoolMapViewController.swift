//
//  SchoolMapViewController.swift
//  MdvApp
//
//  Created by Terry Latanville on 2020-10-01.
//

import SwiftUI
import UIKit

final class SchoolMapViewController: UIViewController {
    override var shouldAutorotate: Bool { false }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    // MARK: - Helper Functions
    private func zoneView(for imageName: String) -> ZoneView {
        return ZoneView(imageName: imageName, dismiss: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
    }


    // MARK: - IBActions
    @IBAction func showZone(_ sender: UIButton) {
        let imageName = sender.title(for: .normal)!.uppercased()
        let view = ZoneView(imageName: imageName, dismiss: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
        present(view, presentationStyle: .fullScreen, transitionStyle: .flipHorizontal)
    }
}

struct ZoneView: View {
    let imageName: String
    var dismiss: (() -> Void)?

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onTapGesture { dismiss?() }
    }
}


struct ZoneView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneView(imageName: "YELLOW ZONE")
    }
}
