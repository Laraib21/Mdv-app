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
    
    @IBOutlet weak var reScanButton: UIButton!
    
    @IBAction func reScanAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "app.mdv.student.id")
        studentID = nil
        studentIdBarcodeViewController?.removeFromParentViewController()
        addChildViewController(barcodeScanningViewController, intoContainer: barcodeView)
        reScanButton.isHidden = true
        UIView.transition(with: studentIDImage, duration: 0.3, options: .transitionCrossDissolve, animations:  {
            self.studentIDImage.image = #imageLiteral(resourceName: "Scan Your Student ID Here")
        })
        UIView.animate(withDuration: 0.3) {
            self.studentIDArrow.isHidden = false
        }
    }
    
    
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
    private lazy var barcodeScanningViewController: BarcodeScanningViewController = {
        let scanningViewController = BarcodeScanningViewController()
        scanningViewController.delegate = self
        return scanningViewController
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
        
        studentID = UserDefaults.standard.string(forKey: "app.mdv.student.id")

        if let studentID = studentID {
            displayBarcode(for: studentID)
        } else {
            #if targetEnvironment(simulator)
                return
            #else
                addChildViewController(barcodeScanningViewController, intoContainer: barcodeView)
            #endif
            
        }
    }
    private var studentIdBarcodeViewController: StudentIdBarcode?
    private func displayBarcode(for studentID: String) {
        studentIdBarcodeViewController = StudentIdBarcode(studentID: studentID)
        addChildViewController(studentIdBarcodeViewController!, intoContainer: barcodeView)
        reScanButton.isHidden = false
        UIView.transition(with: studentIDImage, duration: 0.3, options: .transitionCrossDissolve, animations:  {
            self.studentIDImage.image = #imageLiteral(resourceName: "Your Student ID")
        })
        UIView.animate(withDuration: 0.3) {
            self.studentIDArrow.isHidden = true
        }
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
        barcodeScanningViewController.removeFromParentViewController()
        studentID = barcode
        UserDefaults.standard.set(barcode, forKey: "app.mdv.student.id")
        displayBarcode(for: barcode)

    }
    
    
}

