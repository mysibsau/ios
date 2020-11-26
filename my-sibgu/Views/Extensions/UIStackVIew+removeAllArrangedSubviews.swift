//
//  UIStackVIew+removeAllArrangedSubviews.swift
//  my-sibgu
//
//  Created by art-off on 25.11.2020.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
}
