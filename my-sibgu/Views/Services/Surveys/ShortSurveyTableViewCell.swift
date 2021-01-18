//
//  ShortSurveyTableViewCell.swift
//  my-sibgu
//
//  Created by art-off on 17.01.2021.
//

import UIKit

class ShortSurveyTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ShortSurveyCell"
    
    
    private let containerView = UIView()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.textColor = Colors.sibsuBlue
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
        containerView.layer.cornerRadius = 15
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}