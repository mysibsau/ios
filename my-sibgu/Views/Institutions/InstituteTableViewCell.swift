//
//  InstituteTableViewCell.swift
//  my-sibgu
//
//  Created by art-off on 04.12.2020.
//

import UIKit

class InstituteTableViewCell: UITableViewCell {

    static let reuseIdentifier = "InstituteCell"
    
    
    private let containerView = UIView()
    
    let shortNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let longNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
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
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 15
        containerView.makeShadow(color: .black, opacity: 0.3, shadowOffser: .zero, radius: 4)
        
        containerView.addSubview(shortNameLabel)
        shortNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        shortNameLabel.textColor = Colors.sibsuBlue
        
        containerView.addSubview(longNameLabel)
        longNameLabel.snp.makeConstraints { make in
            make.top.equalTo(shortNameLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        longNameLabel.textColor = Colors.sibsuBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
