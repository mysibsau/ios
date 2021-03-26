//
//  GoodCollectionViewCell.swift
//  my-sibgu
//
//  Created by art-off on 01.02.2021.
//

import UIKit

class GoodCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GoodCell"
    
    // MARK: - Views
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.Pallete.content
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
//    let priceLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.textAlignment = .right
//        label.font = UIFont.systemFont(ofSize: 15)
//        label.textColor = UIColor.Pallete.gray
//        return label
//    }()
    
    
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
    func setupViews() {
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor.Pallete.content
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        self.makeShadow()
        self.makeBorder()
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
        imageView.layer.cornerRadius = 10
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-10)
        }
        nameLabel.text = "f;lk jas;dlfjлдодл ождждло ждло дло ждло ждло длждло ждло ждло"
        
//        contentView.addSubview(priceLabel)
//        priceLabel.snp.makeConstraints { make in
//            make.top.equalTo(nameLabel.snp.bottom).offset(5)
//            make.leading.trailing.equalToSuperview().inset(10)
//            make.bottom.equalToSuperview().offset(-10)
//            make.height.equalTo(20)
//        }
//        priceLabel.text = "100 р"
    }
    
}

extension GoodCollectionViewCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.makeShadow()
        self.makeBorder()
    }
    
}
