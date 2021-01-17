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
    
    // MARK: - Private Views
//    private let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        return stackView
//    }()
//    private let marcheTitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 25)
//        label.textColor = .white
//        return label
//    }()
//    private let numberMarchesLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12)
//        return label
//    }()
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
        label.textColor = Colors.sibsuBlue
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
            make.size.equalTo(90)
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
//            make.centerX.equalToSuperview()
//            make.top.leading.trailing.equalToSuperview().inset(10)
//            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
    }
    
    func updateSize(widthAndHeidth: CGFloat) {
        let widthImage = widthAndHeidth - 60
        imageView.snp.updateConstraints { update in
            update.size.equalTo(widthImage)
            update.leading.trailing.equalToSuperview().inset(30)
        }
        
        // минус отступы
        let labelHeigth = 60 - 10 - 10
        nameLabel.snp.updateConstraints { update in
            update.height.equalTo(labelHeigth)
        }
    }

    
}
