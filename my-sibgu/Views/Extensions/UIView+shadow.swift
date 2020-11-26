//
//  UIView+shadow.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

extension UIView {
    
    func makeShadow(color: UIColor, opacity: Float, shadowOffser: CGSize, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = shadowOffser
        self.layer.shadowRadius = radius
    }
    
}
