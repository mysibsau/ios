//
//  TicketPriceCollectionViewCell.swift
//  my-sibgu
//
//  Created by art-off on 26.03.2021.
//

import UIKit

class TicketPriceCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PriceCell"
    
    // MARK: - Views
    let colorView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        return v
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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
        self.backgroundColor = .clear
        
        self.addSubview(colorView)
        self.addSubview(textLabel)
        
        colorView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.size.equalTo(20)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(colorView.snp.trailing)
        }
    }
    
}
