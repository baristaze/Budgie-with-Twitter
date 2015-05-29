//
//  UIFont+Appearance.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/27/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

extension UIFont {
    class func budgie_primaryFont() -> UIFont {
        return UIFont(name: "Papyrus", size: 14.0)!
    }
}

extension UIColor {
    class func budgieYellow() -> UIColor {
        return UIColor(red: (252.0 / 255.0), green: (248.0 / 255.0), blue: (197.0 / 255.0), alpha: 1)
    }
    
    class func budgieBlue() -> UIColor {
        return UIColor(red: (88.0 / 255.0), green: (145.0 / 255.0), blue: (211.0 / 255.0), alpha: 1)
    }
    
    class func budgieGreen() -> UIColor {
        return UIColor(red: (184.0 / 255.0), green: (233.0 / 255.0), blue: (134.0 / 255.0), alpha: 1)
    }
}