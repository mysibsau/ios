//
//  DesignOfficeTableCell.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import UIKit

class DesignOfficeTableCell: UITableViewCell {

    static let reuseIdentifier = "DesignOfficeCell"
    
    
    private let containerView = UIView()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
            make.height.greaterThanOrEqualTo(70)
        }
        
        containerView.backgroundColor = UIColor.Pallete.content
        containerView.makeShadow()
        containerView.makeBorder()
        containerView.layer.cornerRadius = 35
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.leading.equalToSuperview().inset(35)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DesignOfficeTableCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        containerView.makeShadow()
        containerView.makeBorder()
    }
    
}
