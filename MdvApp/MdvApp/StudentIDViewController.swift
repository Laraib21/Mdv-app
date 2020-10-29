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

    @IBOutlet var barcodeImageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!

    // MARK: - Properties
    private var studentID: String?
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

    // MARK: - UIViewController Overrides
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.white.cgColor

//        if let studentID = studentID {
//            displayBarcode(for: studentID)
//            return
//        }
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

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if captureSession?.isRunning == false {
//            captureSession?.startRunning()
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if captureSession?.isRunning == true {
//            captureSession?.stopRunning()
//        }
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        radialGradientLayer.frame = view.bounds
        if radialGradientLayer.superlayer == nil {
            view.layer.addSublayer(radialGradientLayer)
        }
    }
}

// MARK: - Barcode Display
extension StudentIDViewController {
    private func displayBarcode(for studentID: String) {
        // Generate a barcode image from the student ID #
        // Rotate it by 90 degrees
        guard let barcodeImage = RSUnifiedCodeGenerator.shared.generateCode(studentID, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue) else {
            scanBarcode(withMessage: "Unable to create barcode from \(studentID), try scanning again.")
              return
        }

        barcodeImageView.image = barcodeImage.rotate(radians: .pi / 2)
        barcodeImageView.isHidden = false
    }
}


