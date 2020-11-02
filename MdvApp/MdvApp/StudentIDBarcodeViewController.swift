//
//  StudentIDBarcodeViewController.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2020-10-30.
//

import Foundation
import UIKit
import RSBarcodes_Swift
import AVFoundation

class StudentIdBarcode: UIViewController{
    let studentID: String
    init (studentID:String) {
        self.studentID = studentID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        view = UIImageView.init(image: RSUnifiedCodeGenerator.shared.generateCode(studentID, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue))
    }
}
