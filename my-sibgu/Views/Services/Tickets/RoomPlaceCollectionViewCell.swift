//
//  RoomPlaceCollectionViewCell.swift
//  my-sibgu
//
//  Created by art-off on 05.03.2021.
//

import UIKit

class RoomPlaceCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RoomPlaceCell"
    
    private let circleView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 3
        
        addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(1)
        }
        
        circleView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func circleIsHide(_ hide: Bool, diametr: CGFloat) {
        if hide {
            circleView.isHidden = true
        } else {
            let size = diametr * 0.7
            
            circleView.isHidden = false
            circleView.snp.updateConstraints { update in
                update.size.equalTo(size)
            }
            circleView.layer.cornerRadius = size / 2
        }
    }
    
}
