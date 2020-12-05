//
//  UIImageView+loadImage.swift
//  my-sibgu
//
//  Created by art-off on 05.12.2020.
//

import UIKit

/// thanks for it https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/

extension UIImageView {
    
    func loadImage(at url: URL) {
        UIImageLoader.loader.load(url, for: self)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
    
}
