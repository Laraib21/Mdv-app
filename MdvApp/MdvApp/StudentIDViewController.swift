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
    
    @IBOutlet weak var studentIDImage: UIImageView!
    
    @IBOutlet weak var studentIDArrow: UIImageView!
    
    
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
        } else {
            #if targetEnvironment(simulator)
                return
            #else
            barcodeScanningViewController.delegate = self
                addChildViewController(barcodeScanningViewController, intoContainer: barcodeView)
            #endif
            
        }
        
        UserDefaults.standard.set(String.self, forKey: "app.mdv.student.id")
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

extension StudentIDViewController: BarcodeScanningViewControllerDelegate{
    func scanner(found barcode: String) {
        print("barcode found")
        print(barcode)
        barcodeScanningViewController.removeFromParentViewController()
        studentID = barcode
        displayBarcode(for: barcode)
        let possibleStudentId = UserDefaults.standard.string(forKey: "app.mdv.student.id")
    }
    
    
}

