//
//  UIColor+Pallete.swift
//  my-sibgu
//
//  Created by art-off on 19.01.2021.
//

import UIKit

extension UIColor {
    
    struct Pallete {
        
        static let orange = UIColor.color(light: .init(hex: "#F48041"), dark: .init(hex: "#F48041"))
        
        static let green = UIColor.color(light: .init(hex: "#359f2f"), dark: .init(hex: "#359f2f"))
        
        static let purple = UIColor.color(light: .init(hex: "c0a747"), dark: .init(hex: "c0a747"))
        
        
        static let lightRed = UIColor.color(light: UIColor(red: 255.0/255.0, green: 117.0/255.0, blue: 118.0/255.0, alpha: 1),
                                            dark: UIColor(red: 255.0/255.0, green: 117.0/255.0, blue: 118.0/255.0, alpha: 1))
        
        static let darkBlue = UIColor.color(light: UIColor(red: 22.0/255.0, green: 89.0/255.0, blue: 132.0/255.0, alpha: 1.0),
                                            dark: UIColor(red: 22.0/255.0, green: 89.0/255.0, blue: 132.0/255.0, alpha: 1.0))
        
        static let sibsuGreen = UIColor.color(light: UIColor(red: 138.0/255.0, green: 189.0/255.0, blue: 100.0/255.0, alpha: 1.0),
                                             dark: UIColor(red: 138.0/255.0, green: 189.0/255.0, blue: 100.0/255.0, alpha: 1.0))
        
        static let sibsuBlue = UIColor.color(light: UIColor(red: 75.0/255.0, green: 123.0/255.0, blue: 184.0/255.0, alpha: 1.0),
                                             dark: UIColor(red: 75.0/255.0, green: 123.0/255.0, blue: 184.0/255.0, alpha: 1.0))
        
    }
    
}
