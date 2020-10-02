//
//  splashBarController.swift
//  MdvApp
//
//  Created by School on 2020-09-14.
//

import Foundation
import UIKit

class SplashTapBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            let loadingScreenView = LoadingScreenView(dismiss: self.dismissLoadingScreen)
            // self.present(loadingScreenView, animated: false, presentationStyle: .fullScreen)
        }
    }

    private func dismissLoadingScreen() -> Void {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
