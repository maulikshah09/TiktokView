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

}

 

