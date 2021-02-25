//
//  DinerTableViewCell.swift
//  my-sibgu
//
//  Created by art-off on 20.02.2021.
//

import UIKit

class DinerTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DinerCell"
    
    
    private let containerView = UIView()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let includedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.Pallete.gray
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.backgroundColor = UIColor.Pallete.content
        containerView.makeShadow(radius: 3)
        containerView.makeBorder()
        containerView.layer.cornerRadius = 15
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(weightLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(includedLabel)
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(priceLabel.snp.leading)
            make.width.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(10)
            make.trailing.equalTo(weightLabel.snp.leading)
        }
        
        includedLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(weightLabel.snp.leading)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DinerTableViewCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        containerView.makeShadow(radius: 3)
        containerView.makeBorder()
    }
    
}
