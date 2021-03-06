//
//  CenterLabelView.swift
//  my-sibgu
//
//  Created by art-off on 05.12.2020.
//

import UIKit
import SnapKit

class CenterLabelView: UIView {
    
    let centerLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    init(text: String) {
        self.init()
        centerLabel.text = text
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.Pallete.content
        self.layer.cornerRadius = 20
        makeShadow()
        makeBorder()
        
        self.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        centerLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        centerLabel.textColor = UIColor.Pallete.sibsuBlue
        centerLabel.textAlignment = .center
        centerLabel.numberOfLines = 0
        centerLabel.lineBreakMode = .byWordWrapping
    }

}

extension CenterLabelView {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        makeShadow()
        makeBorder()
    }
    
}
