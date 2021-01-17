//
//  CollectionViewHelper.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import UIKit

class CollectionViewHelper {
    
    static func getItemWidth(byCollectionViewWidth collectionViewWidth: CGFloat,
                             numberItemsPerLine: Int,
                             spacing: CGFloat) -> CGFloat {
        
        let spaceForItemsWithoutSpacing = Int(collectionViewWidth - CGFloat(numberItemsPerLine + 1) * spacing)
        return CGFloat(Int(spaceForItemsWithoutSpacing / numberItemsPerLine))
    }
    
}
