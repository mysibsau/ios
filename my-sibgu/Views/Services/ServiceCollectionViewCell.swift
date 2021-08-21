//
//  ServiceCollectionViewCell.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import UIKit
import SnapKit

class ServiceCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ServiceCell"
    
    // MARK: - Views
    var viewWithImage: UIView = {
        let imageView = UIView()
//        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    
    // MARK: - Overrides
    override init(frame: CGRect) { 
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor.Pallete.content
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        self.makeShadow()
        self.makeBorder()
    }
    
    func configure(viewWithImage: UIView) {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        
        self.viewWithImage = viewWithImage
        self.viewWithImage.clipsToBounds = true
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.leading.trailing.equalToSuperview().inset(5)
        }
        
        contentView.addSubview(viewWithImage)
        viewWithImage.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(5)
            make.width.equalTo(viewWithImage.snp.height)
        }
    }
    
}

extension ServiceCollectionViewCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.makeShadow()
        self.makeBorder()
    }
    
}
