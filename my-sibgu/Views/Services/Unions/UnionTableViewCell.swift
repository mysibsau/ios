//
//  UnionTableViewCell.swift
//  my-sibgu
//
//  Created by art-off on 28.12.2020.
//

import UIKit

class UnionTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UnionCell"
    
    
    private let containerView = UIView()
    
    
    let logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.backgroundColor = .systemBackground
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.backgroundColor = .systemBackground
        containerView.makeShadow(color: .black, opacity: 0.3, shadowOffser: .zero, radius: 4)
        
        containerView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(5)
            make.size.equalTo(60)
        }
        logoImageView.layer.borderColor = UIColor.Pallete.gray.cgColor
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.cornerRadius = 30
        // (60 + 5 + 5) / 2 = 35
        containerView.layer.cornerRadius = 35
        
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(10)
            make.centerY.equalTo(logoImageView)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        logoImageView.cancelImageLoad()
        logoImageView.image = nil
    }

}
