//
//  UIImage+Barcode.swift
//  MdvApp
//
//  Created by Terry Latanville on 2020-08-12.
//

import UIKit

extension UIImage {
    convenience init?(barcode: String) {
        let data = barcode.data(using: .utf8)
        guard let filter = CIFilter(name: "CICode39BarcodeGenerator") else { return nil }

        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else { return nil }
        self.init(ciImage: ciImage)
    }
    func rotateDegrees(_ degrees: CGFloat) -> UIImage? {
        let radians = self.radians(from: degrees)
        return rotate(radians: radians)
    }
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: radians)
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    func radians(from degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180
    }
}
