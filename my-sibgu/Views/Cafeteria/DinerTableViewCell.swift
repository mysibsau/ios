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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        containerView.makeShadow()
        containerView.makeBorder()
        containerView.layer.cornerRadius = 15
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(weightLabel)
        containerView.addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(65)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(priceLabel.snp.leading)
            make.width.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(weightLabel.snp.leading)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DinerTableViewCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        containerView.makeShadow()
        containerView.makeBorder()
    }
    
}
