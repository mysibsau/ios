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
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
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
    func setupViews() {
        layer.cornerRadius = 15
        backgroundColor = .systemBackground
        makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 3.5)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.bottom.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
    }
    
}
