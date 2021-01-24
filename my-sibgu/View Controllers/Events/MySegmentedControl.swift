//
//  MySegmentedControl.swift
//  my-sibgu
//
//  Created by art-off on 14.01.2021.
//

import UIKit
import SnapKit

class MySegmentedControl: UIView {
    
    private var labelWidth: CGFloat
    
    private let stackView: UIStackView
    
    private let items: [String]
    private let lineView: UIView
    var sectionLabels: [UILabel]
    
    
    init(items: [String], sectionWidth: CGFloat) {
        self.items = items
        self.labelWidth = sectionWidth
        
        sectionLabels = []
        for item in items {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.text = item
            sectionLabels.append(label)
        }
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.Pallete.sibsuBlue
        
        
        super.init(frame: .zero)
        
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
        }
        
        for label in sectionLabels {
            label.snp.makeConstraints { make in
                make.width.equalTo(labelWidth)
            }
            stackView.addArrangedSubview(label)
        }
        
        self.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(labelWidth)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        setCurrentSection(number: 0)
        
        for label in sectionLabels {
            label.isUserInteractionEnabled = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat(sectionLabels.count) * labelWidth, height: 36)
    }
    
    func setLineOffset(percentageOffset: CGFloat) {
        lineView.snp.updateConstraints { update in
            update.leading.equalTo(percentageOffset * labelWidth)
        }
        lineView.layoutIfNeeded()
    }
    
    func setCurrentSection(number: Int) {
        for label in sectionLabels {
            label.textColor = .gray
        }
        sectionLabels[number].textColor = .label
    }
    
}
