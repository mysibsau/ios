//
//  UIView+constraints.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

extension UIView {
    
    func addConstraintsOnAllSides(to toView: UIView, withConstant: CGFloat) {
        self.topAnchor.constraint(equalTo: toView.topAnchor, constant: withConstant).isActive = true
        self.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: withConstant).isActive = true
        self.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -withConstant).isActive = true
        self.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: -withConstant).isActive = true
    }
    
    func addConstraintsOnAllSides(to toView: UIView, withConstantForTop: CGFloat, leadint: CGFloat, trailing: CGFloat, bottom: CGFloat) {
        self.topAnchor.constraint(equalTo: toView.topAnchor, constant: withConstantForTop).isActive = true
        self.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: leadint).isActive = true
        self.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: trailing).isActive = true
        self.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: bottom).isActive = true
    }
    
    func addConstraintsOnAllSides(to toLayoutGuide: UILayoutGuide, withConstant: CGFloat) {
        self.topAnchor.constraint(equalTo: toLayoutGuide.topAnchor, constant: withConstant).isActive = true
        self.leadingAnchor.constraint(equalTo: toLayoutGuide.leadingAnchor, constant: withConstant).isActive = true
        self.trailingAnchor.constraint(equalTo: toLayoutGuide.trailingAnchor, constant: -withConstant).isActive = true
        self.bottomAnchor.constraint(equalTo: toLayoutGuide.bottomAnchor, constant: -withConstant).isActive = true
    }
    
    func addConstraintsOnAllSides(to toLayoutGuide: UILayoutGuide, withConstantForTop: CGFloat, leadint: CGFloat, trailing: CGFloat, bottom: CGFloat) {
        self.topAnchor.constraint(equalTo: toLayoutGuide.topAnchor, constant: withConstantForTop).isActive = true
        self.leadingAnchor.constraint(equalTo: toLayoutGuide.leadingAnchor, constant: leadint).isActive = true
        self.trailingAnchor.constraint(equalTo: toLayoutGuide.trailingAnchor, constant: trailing).isActive = true
        self.bottomAnchor.constraint(equalTo: toLayoutGuide.bottomAnchor, constant: bottom).isActive = true
    }
}
