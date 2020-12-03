//
//  BuildingTableViewCell.swift
//  my-sibgu
//
//  Created by art-off on 03.12.2020.
//

import UIKit
import SnapKit

class BuildingTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "BuildingCell"
    
    
    private let containerView = UIView()
    
    private let buildingNameLabel = UILabel()
    private let buildingTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private let buildingAddressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let separateLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self).inset(5)
            make.leading.trailing.equalTo(self).inset(20)
//            make.height.equalTo(40)
        }
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 15
        containerView.makeShadow(color: .black, opacity: 0.3, shadowOffser: .zero, radius: 4)
        
        containerView.addSubview(buildingNameLabel)
        buildingNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
        buildingNameLabel.text = "\"А\""
        
        containerView.addSubview(separateLine)
        separateLine.snp.makeConstraints { make in
            make.leading.equalTo(buildingNameLabel.snp.trailing)
            make.width.equalTo(2)
            make.height.equalToSuperview()
        }
        separateLine.backgroundColor = Colors.sibsuBlue
        
        containerView.addSubview(buildingTypeLabel)
        buildingTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(separateLine.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(2)
        }
        
        containerView.addSubview(buildingAddressLabel)
        buildingAddressLabel.snp.makeConstraints { make in
            make.leading.equalTo(separateLine.snp.trailing).offset(10)
            make.top.equalTo(buildingTypeLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview().offset(-2)
        }
        
        buildingTypeLabel.text = "Корпус"
        buildingAddressLabel.text = "пр. Красраб 31 знадине позади"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        self.addSubview(containerView)
//        containerView.snp.makeConstraints { make in
//            make.top.bottom.equalTo(self).inset(20)
//            make.leading.trailing.equalTo(self).inset(20)
//            make.height.equalTo(60)
//        }
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
