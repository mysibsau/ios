//
//  MySegmentedControl.swift
//  my-sibgu
//
//  Created by art-off on 14.01.2021.
//

import UIKit
import SnapKit

class MySegmentedControl: UIView {
    
    var lineView: UIView!
    var sectionsLabel: [UILabel]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let firstSectionTitleLabel = UILabel()
        firstSectionTitleLabel.textAlignment = .center
        firstSectionTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        firstSectionTitleLabel.text = "Новости"
        let secondSectionTitleLabel = UILabel()
        secondSectionTitleLabel.textAlignment = .center
        secondSectionTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        secondSectionTitleLabel.text = "События"
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.Pallete.sibsuBlue
        
        self.addSubview(firstSectionTitleLabel)
        firstSectionTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(20)
            make.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
        }
        self.addSubview(secondSectionTitleLabel)
        secondSectionTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(20)
            make.top.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
        }
        self.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(90)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        sectionsLabel = [
            secondSectionTitleLabel,
            firstSectionTitleLabel,
        ]
        
        sectionsLabel[0].textColor = .label
        sectionsLabel[1].textColor = .gray
        
        sectionsLabel[0].tag = 0
        sectionsLabel[1].tag = 1
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(eventsOrNewsTapped))
//        let tap2 = UITapGestureRecognizer(target: self, action: #selector(aaa))
//        sectionsLabel[0].isUserInteractionEnabled = true
        
        sectionsLabel[0].isUserInteractionEnabled = true
        sectionsLabel[1].isUserInteractionEnabled = true
//        sectionsLabel[0].addGestureRecognizer(tap)
//        sectionsLabel[1].addGestureRecognizer(tap2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc private func eventsOrNewsTapped() {
//        print("lksdf;lakdjsfl ;kasjdl ;fkjasdl;fj sd ")
//    }
//
//    @objc private func aaa() {
//        print("lskhdf")
//    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 180, height: 36)
    }
    
}
