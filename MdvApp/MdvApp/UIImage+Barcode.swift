//
//  UIImage+Barcode.swift
//  MdvApp
//
//  Created by Terry Latanville on 2020-08-12.
//

import UIKit

extension UIImage {
    convenience init?(barcode: String, transform: CGAffineTransform = .identity) {
        let data = barcode.data(using: .ascii)
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }

        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage?.transformed(by: transform) else { return nil }
        self.init(ciImage: ciImage)
    }
}
