//
//  UIViewExt.swift
//  live
//
//  Created by Maulik Shah on 12/19/24.
//
import UIKit

import CoreGraphics

@IBDesignable open class DesignableView: UIView {
}

@IBDesignable open class DesignableButton: UIButton {
}


@IBDesignable open class DesignableLabel: UILabel {
}

@IBDesignable open class DesignableTextView: UITextView {
}

@IBDesignable open class DesignableText: UITextField {
}

@IBDesignable open class DesignableImageView: UIImageView {
}

@objc
public extension UIView  {
    // Note  : Corner radius and shadow not work both side by side so you need to outlet and set layer radius
    // other wise you can set layer.cornerradius in user defines
    //MARK: Border COLOR
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return self.borderColor
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    //MARK: Border Width
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    //MARK: corner Radius
    @IBInspectable
    var cornerRadius: CGFloat{
        get {
            return self.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable
    var isCircle: Bool{
        get {
            return false
        }
        set {
            if newValue == true {
                layer.cornerRadius = frame.height / 2
                layer.masksToBounds = true
            }
        }
    }
    //MARK: Shadow Properties
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    var zPosition: CGFloat {
        get { return layer.zPosition }
        set { layer.zPosition = newValue }
    }

    //MARK: set bottom border
    @IBInspectable
    var bottomBorderColor:UIColor {
        get {
            return self.bottomBorderColor
        }
        set {
            //self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.masksToBounds = false
            self.layer.shadowColor = newValue.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 0.0
        }
    }

    @IBInspectable
    var shake:Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                self.transform = CGAffineTransform(translationX: 20, y: 0)
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }

}

//shdow for navigation and tabbar
public enum VerticalLocation: String {
    case bottom
    case top
}

public extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0,offset : CGSize) {
        switch location {
        case .bottom:
            addShadow(offset: offset, color: color, opacity: opacity, radius: radius)
        case .top: // pass minus
            addShadow(offset: offset, color: color, opacity: opacity, radius: radius)
        }
    }
    
    
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

//Different Corner Radius,shadow border 
public extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

public extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
