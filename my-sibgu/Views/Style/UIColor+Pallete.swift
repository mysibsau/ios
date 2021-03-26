//
//  UIColor+Pallete.swift
//  my-sibgu
//
//  Created by art-off on 19.01.2021.
//

import UIKit

extension UIColor {
    
    struct Pallete {
        
        // Если какой-то цвет не нужен в одной из тем (напирмер тень) - можно поставить .clear
        
        static let background = UIColor.color(light: .init(hex: "FFFFFF"), dark: .init(hex: "373737"))
        
        static let content = UIColor.color(light: .init(hex: "FFFFFF"), dark: .init(hex: "262626"))
        
        static let shadow = UIColor.color(light: .init(hex: "000000"), dark: .clear)
        
        static let border = UIColor.color(light: .clear, dark: .gray)
        
        static let blackOrWhite = UIColor.color(light: .init(hex: "000000"), dark: .init(hex: "FFFFFF"))
        static let whiteOrBlack = UIColor.color(light: .init(hex: "FFFFFF"), dark: .init(hex: "000000"))
        
        
        static let gray = UIColor.color(light: .init(hex: "757575"), dark: .init(hex: "c9c7c7"))
        
        static let orange = UIColor.color(light: .init(hex: "#F48041"), dark: .init(hex: "#F48041"))
        
        static let green = UIColor.color(light: .init(hex: "#359f2f"), dark: .init(hex: "#359f2f"))
        
        static let purple = UIColor.color(light: .init(hex: "c0a747"), dark: .init(hex: "c0a747"))
        
        
        static let lightRed = UIColor.color(light: .init(hex: "ff7575"), dark: .init(hex: "ff7575"))
        
        static let darkBlue = UIColor.color(light: .init(hex: "165984"), dark: .init(hex: "377fde"))
        
        static let sibsuGreen = UIColor.color(light: .init(hex: "8bbd64"), dark: .init(hex: "8bbd64"))
        
        static let sibsuBlue = UIColor.color(light: .init(hex: "4b7ab8"), dark: .init(hex: "377fde"))
        
        
        static let white = UIColor.init(hex: "FFFFFF")
        
        
        struct Special {
            static let segmentedControl = UIColor.color(light: .init(hex: "FFFFFF"), dark: .init(hex: "090908"))
            static let tabNavBar = UIColor.color(light: .init(hex: "F9F9F9"), dark: .init(hex: "101010"))
            
            static let priceColors = [
                green,
                purple,
                lightRed,
                sibsuBlue,
                sibsuGreen,
                orange,
            ]
            
            static let inactiveCell = UIColor.color(light: .init(hex: "E1E1E1"), dark: .init(hex: "c9c7c7"))
        }
        
    }
    
}
