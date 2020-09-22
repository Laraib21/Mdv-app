//
//  UIColor+Hex.swift
//  MdvApp
//
//  Created by Terry Latanville on 2020-09-04.
//

import UIKit
import SwiftUI

extension UIColor {
    convenience init?(hexValue: String) {
        guard let (red, green, blue, alpha) = hexValue.asRGBA else { return nil }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Color {
    init?(hexValue: String) {
        guard let uiColor = UIColor(hexValue: hexValue) else { return nil }
        self.init(uiColor)
    }
}

extension String {
    var asRGBA: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        guard let (hexNumber, trimmedStringCount) = self.asHexInt64 else { return nil }
        let r, g, b, a: CGFloat
        switch trimmedStringCount {
        case 3: // #RGB
            r = CGFloat((hexNumber & 0xf00) >> 16) / 255
            g = CGFloat((hexNumber & 0x0f0) >> 8) / 255
            b = CGFloat(hexNumber & 0x00f) / 255
            a = 1
        case 6: // #RRGGBB
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000ff) / 255
            a = 1
        case 8: // #RRGGBBAA
            r = CGFloat((hexNumber & 0xff0000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff) >> 8) / 255
            a = CGFloat(hexNumber & 0x0000ff) / 255

        default:
            return nil
        }
        return (r, g, b, a)
    }

    var asHexInt64: (value: UInt64, count: Int)? {
        let start: Index
        if hasPrefix("0x") {
            start = index(startIndex, offsetBy: 2)
        } else if hasPrefix("#") {
            start = index(after: startIndex)
        } else {
            start = startIndex
        }
        let hexColor = String(self[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        return scanner.scanHexInt64(&hexNumber) ? (hexNumber, hexColor.count) : nil
    }
}
