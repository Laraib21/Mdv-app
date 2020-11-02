//
//  StudentIDViewController.swift
//  MdvApp
//
//  Created by Terry Latanville on 2020-08-12.
//

import AVFoundation
import UIKit
import RSBarcodes_Swift

final class StudentIDViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var borderView: UIView!
    @IBOutlet var gradientView: UIView!

    @IBOutlet var barcodeView: UIView!
    

    // MARK: - Properties
    private var studentID: String? = "621833"
    private lazy var radialGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial
        gradientLayer.colors = [
            UIColor(hexValue: "#0041d1")!.cgColor,
            UIColor(hexValue: "#0019b3")!.cgColor,
        ]

        let screenRatio = view.frame.width / view.frame.height / 2
        let startPoint = CGPoint(x: 0.5, y: 0.8)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = CGPoint(x: 1, y: startPoint.y + screenRatio)
        return gradientLayer
    }()
    private lazy var barcodeScanningViewController = BarcodeScanningViewController()
    // MARK: - UIViewController Overrides
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.white.cgColor
        
    

        if let studentID = studentID {
            displayBarcode(for: studentID)
            return
        }
//        #if targetEnvironment(simulator)
//        toggleBarcodeView(false)
//        #else
//        do {
//            try configureCaptureSession()
//        } catch {
//            captureSession = nil
//            print("Encountered error starting capture session: \(error)")
//        }
//        #endif
    }

    private func displayBarcode(for studentID: String) {
        let StudentIdBarcodeViewController = StudentIdBarcode(studentID: studentID)
        addChildViewController(StudentIdBarcodeViewController, intoContainer: barcodeView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let origin = CGPoint(x: 0, y: -66)
        let size = CGSize(width: gradientView.bounds.size.width, height: gradientView.bounds.size.height + 66)
        radialGradientLayer.frame = CGRect(origin: origin, size: size)
        if radialGradientLayer.superlayer == nil {
            gradientView.layer.addSublayer(radialGradientLayer)
        }
    }
}



