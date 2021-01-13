//
//  BlurImageView.swift
//  my-sibgu
//
//  Created by art-off on 13.01.2021.
//

import UIKit

class BlurImageView: UIImageView {
    
    var blurRadius: CGFloat = 2
    
    override var image: UIImage? {
        set {
            super.image = newValue?.blurred(radius: blurRadius)
        }
        get {
            return super.image
        }
    }
    
}
