//
//  StudentIDViewController.swift
//  MdvApp
//
//  Created by Terry Latanville on 2020-08-12.
//

import AVFoundation
import UIKit

final class StudentIDViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var barcodeScanningView: UIView!
    @IBOutlet var barcodeImageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!

    // MARK: - Properties
    private var studentID: String?
    private var captureSession: AVCaptureSession?

    // MARK: - UIViewController Overrides
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let studentID = studentID {
            displayBarcode(for: studentID)
            return
        }
        #if targetEnvironment(simulator)
        toggleBarcodeView(false)
        #else
        do {
            try configureCaptureSession()
        } catch {
            captureSession = nil
            print("Encountered error starting capture session: \(error)")
        }
        #endif
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
}

// MARK: - Barcode Display
extension StudentIDViewController {
    private func displayBarcode(for studentID: String) {
        // Generate a barcode image from the student ID #
        // Rotate it by 90 degrees
    //    guard let barcodeImage = UIImage(barcode: studentID) else {
      //      scanBarcode(withMessage: "Unable to create barcode from \(studentID), try scanning again.")
        //      return
     //   }

        barcodeImageView.image = barcodeImage.rotate(radians: .pi / 2)
        barcodeImageView.isHidden = false
    }
}


// MARK: - Barcode Scanning
extension StudentIDViewController {
    private func configureCaptureSession() throws {
        // Set up the AVCaptureSession
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Unable to start AVCaptureDevice, aborting")
            return
        }
        try addVideoInput(from: videoCaptureDevice, to: captureSession)
        try addMetadataOutput(to: captureSession)
        addPreviewLayer(for: captureSession, to: barcodeScanningView)

        self.captureSession = captureSession
        scanBarcode(withMessage: "Scan your student ID to create a virtual student card.")
    }

    private func scanBarcode(withMessage message: String) {
        messageLabel.text = message
        toggleBarcodeView(false)
    }

    private func scanner(found barcode: String) {
        toggleBarcodeView(true)
        displayBarcode(for: barcode)
    }

    // MARK: - Helpers
    private func addVideoInput(from device: AVCaptureDevice, to captureSession: AVCaptureSession) throws {
        let videoInput = try AVCaptureDeviceInput(device: device)
        guard captureSession.canAddInput(videoInput) else {
            throw NSError(domain: "mdv.student.barcode.input", code: 0, userInfo: nil)
        }
        captureSession.addInput(videoInput)
    }

    private func addMetadataOutput(to captureSession: AVCaptureSession) throws {
        let metadataOutput = AVCaptureMetadataOutput()
        guard captureSession.canAddOutput(metadataOutput) else {
            throw NSError(domain: "mdv.student.barcode.output", code: 0, userInfo: nil)
        }
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [.code39]
    }

    private func addPreviewLayer(for captureSession: AVCaptureSession, to barcodeScanningView: UIView) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = barcodeScanningView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        barcodeScanningView.layer.addSublayer(previewLayer)
    }

    private func toggleBarcodeView(_ isHidden: Bool) {
        messageLabel.isHidden = isHidden
        barcodeScanningView.isHidden = isHidden
    }
}

extension StudentIDViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let barcodeValue = metadataObject.stringValue else {
            // TODO: Show an error message
            print("Unable to scan item, continuing")
            return
        }
        captureSession?.stopRunning()
        scanner(found: barcodeValue)
    }
}
