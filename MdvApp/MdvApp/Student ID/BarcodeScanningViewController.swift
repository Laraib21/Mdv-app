//
//  BarcodeScanningViewController.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-10-29.
//

import Foundation
import AVFoundation
import UIKit

protocol BarcodeScanningViewControllerDelegate: AnyObject {
    func scanner(found barcode: String)
}

// MARK: - Barcode Scanning
final class BarcodeScanningViewController: UIViewController{
    // MARK: - Properties
    private var captureSession: AVCaptureSession?
    weak var delegate: BarcodeScanningViewControllerDelegate?
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - Object Lifecycle
    init(delegate: BarcodeScanningViewControllerDelegate? = nil) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    private func configureCaptureSession() throws {
        // Set up the AVCaptureSession
        let captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Unable to start AVCaptureDevice, aborting")
            return
        }
        try addVideoInput(from: videoCaptureDevice, to: captureSession)
        try addMetadataOutput(to: captureSession)
        addPreviewLayer(for: captureSession, to: view)
        self.captureSession = captureSession
    }
    
    private func addVideoInput(from device: AVCaptureDevice, to captureSession: AVCaptureSession) throws {
        let videoInput = try AVCaptureDeviceInput(device: device)
        guard captureSession.canAddInput(videoInput) else {
            throw NSError(domain: "mdv.student.barcode.input", code: 0, userInfo: nil)
        }
        captureSession.addInput(videoInput)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            do {
                try configureCaptureSession()
            } catch {
                captureSession = nil
                print("Encountered error starting capture session: \(error)")
            }
        }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
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
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = barcodeScanningView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        barcodeScanningView.layer.addSublayer(previewLayer)
    }
}

extension BarcodeScanningViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let barcodeValue = metadataObject.stringValue else {
            // TODO: Show an error message
            print("Unable to scan item, continuing")
            return
        }
        captureSession?.stopRunning()
        delegate?.scanner(found: barcodeValue)
    }
}

