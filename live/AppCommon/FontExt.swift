//
//  FontExt.swift
//  live
//
//  Created by Maulik Shah on 12/19/24.
//

import UIKit

// MARK: - Font Declare here
public enum AppFont: String {
    
    case regular        = "SFProText-Regular"
    case medium         = "SFProText-Medium"
    case semiBold       = "SFProText-Semibold"
 
    
    func of(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

// Use Like that
//AppFont.regular(20)
