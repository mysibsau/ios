//
//  UIColor+color.swift
//  my-sibgu
//
//  Created by art-off on 19.01.2021.
//

import UIKit

extension UIColor {
    
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor.init { traitCollection in
            (traitCollection.userInterfaceStyle == .dark) ? dark : light
        }
    }
    
}
