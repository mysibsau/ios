//
//  CancertTableViewCell.swift
//  my-sibgu
//
//  Created by art-off on 25.03.2021.
//

import UIKit

class CancertTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ConcertCell"
    
    
    private let containerView = UIView()
    
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let weekdayAndTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.gray
        return label
    }()
    
    let hallLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.gray
        return label
    }()
    
    private let priceLabelView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.Pallete.sibsuBlue
        v.layer.cornerRadius = 10
        return v
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.Pallete.white
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
        
        containerView.addSubview(dateLabel)
        containerView.addSubview(weekdayAndTimeLabel)
        containerView.addSubview(hallLabel)
        containerView.addSubview(priceLabelView)
        
        dateLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        weekdayAndTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        priceLabelView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
        priceLabelView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        hallLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        
        priceLabel.text = "от 120000 р"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CancertTableViewCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        containerView.makeShadow()
        containerView.makeBorder()
    }
    
}
