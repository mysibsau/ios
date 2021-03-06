//
//  RoomPlaceCollectionViewCell.swift
//  my-sibgu
//
//  Created by art-off on 05.03.2021.
//

import UIKit

class RoomPlaceCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RoomPlaceCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .link
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
