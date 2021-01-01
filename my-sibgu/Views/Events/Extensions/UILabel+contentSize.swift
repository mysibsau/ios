//
//  UILabel+contentSize.swift
//  my-sibgu
//
//  Created by art-off on 01.01.2021.
//

import Foundation
import UIKit

extension UILabel {
    
    var contentSize: CGSize {
        guard
            let text = self.text,
            let font = self.font
        else {
            return .zero
        }
        return text.size(withAttributes: [.font: font])
    }
    
}
