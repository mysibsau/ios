//
//  CenterTitleButton.swift
//  my-sibgu
//
//  Created by art-off on 18.01.2021.
//

import UIKit

class CenterTitleButton: UIButton {

    var borderWidth: CGFloat = 2.0
    var borderColor = UIColor.white.cgColor
    
    var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup() {
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        self.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 4)
        self.layer.cornerRadius = 15
        self.backgroundColor = .systemBackground
    }

}
