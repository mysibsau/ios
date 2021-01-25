//
//  UIView+shadow.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

extension UIView {
    
    func makeShadow(color: UIColor = UIColor.Pallete.shadow,
                    opacity: Float = 0.4,
                    shadowOffser: CGSize = .zero,
                    radius: CGFloat = 4) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = shadowOffser
        self.layer.shadowRadius = radius
    }
    
    func makeBorder(color: UIColor = UIColor.Pallete.border, width: CGFloat = 0.75) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
}
