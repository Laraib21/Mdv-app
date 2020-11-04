//
//  UIViewController+Convenience.swift
//  MdvApp
//
//  Created by Terry Latanville on 2020-08-12.
//

import UIKit
import SwiftUI

extension UIViewController {
    func present<V: View>(_ view: V, animated: Bool = true, presentationStyle: UIModalPresentationStyle = .automatic, transitionStyle: UIModalTransitionStyle = .coverVertical) {
       let hostingController = UIHostingController(rootView: view)
       hostingController.modalPresentationStyle = presentationStyle
       hostingController.modalTransitionStyle = transitionStyle
       present(hostingController, animated: animated, completion: nil)
    }

    func addChildViewController(_ childViewController: UIViewController, intoContainer containerView: UIView) {
        // Disable translatesAutoresizingMaskIntoConstraints to avoid redundant/conflicting constraints when inside the container view
        let childView = childViewController.view!
        childView.translatesAutoresizingMaskIntoConstraints = false
        addChild(childViewController)
        childViewController.beginAppearanceTransition(true, animated: false)

        containerView.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            childView.topAnchor.constraint(equalTo: containerView.topAnchor),
            childView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        childViewController.endAppearanceTransition()
        childViewController.didMove(toParent: self)
    }
    
    func removeFromParentViewController(){
        willMove(toParent: nil)
        beginAppearanceTransition(false, animated: true)
        view.removeFromSuperview()
        endAppearanceTransition()
        removeFromParent()
    }
    
}

