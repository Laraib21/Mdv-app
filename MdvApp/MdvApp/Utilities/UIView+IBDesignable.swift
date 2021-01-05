//
//  UIView+IBDesignable.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2021-01-02.
//

import Foundation
import UIKit

@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var shadowColor:UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
        
    }
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue}
        get { layer.shadowOffset }
    }
    @IBInspectable var shadowRadius: CGFloat {
        set { layer.shadowRadius = newValue}
        get { layer.shadowRadius }
    }
    @IBInspectable var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { layer.shadowOpacity }
    }
}
