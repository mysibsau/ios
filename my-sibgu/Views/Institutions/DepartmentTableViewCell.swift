//
//  DepartmentTableViewCell.swift
//  my-sibgu
//
//  Created by art-off on 28.12.2020.
//

import UIKit
import SnapKit

class DepartmentTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DepartmentCell"
    
    private let containerView = UIView()
    
    var con: Constraint!
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let headNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
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
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            con = make.top.leading.trailing.equalToSuperview().inset(10).constraint
//            make.bottom.equalToSuperview()
        }
        nameLabel.textColor = Colors.sibsuBlue
        
        containerView.addSubview(headNameLabel)
        headNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        
        nameLabel.text = "nksdlkjsdf sdf sd"
        headNameLabel.text = "sdfsd"
        headNameLabel.isHidden = true
        
        headNameLabel.snp.removeConstraints()
        nameLabel.snp.remakeConstraints { make in
            con = make.edges.equalToSuperview().inset(10).constraint
        }
        
//        shortNameLabel.text = "ИИКТ"
//        longNameLabel.text = "Институт информатики и телекомуникаций"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("hellksjd")
        
        headNameLabel.snp.removeConstraints()
        nameLabel.snp.removeConstraints()
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(40).priority(999)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }

}
