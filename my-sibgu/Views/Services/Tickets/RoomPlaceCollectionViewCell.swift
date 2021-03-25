//
//  RoomPlaceCollectionViewCell.swift
//  my-sibgu
//
//  Created by art-off on 05.03.2021.
//

import UIKit

class RoomPlaceCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RoomPlaceCell"
    
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 3
        
        addSubview(textLabel)
        
        textLabel.adjustsFontSizeToFitWidth = true
        
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
