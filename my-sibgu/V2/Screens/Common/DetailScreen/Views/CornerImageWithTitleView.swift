//
//  CornerImageWithTitleView.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.08.2021.
//

import UIKit

class CornerImageWithTitleView: UIView {
    
    let logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.backgroundColor = UIColor.Pallete.white
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    var action: () -> Void = { }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public init(text: String, imageUrl: URL, action: @escaping () -> Void) {
        self.init()
        self.nameLabel.text = text
        logoImageView.loadImage(at: imageUrl)
        self.action = action
    }
    
    func setupView() {
        self.backgroundColor = UIColor.Pallete.content
        self.layer.cornerRadius = 20
        makeShadow()
        makeBorder()
        
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(5)
            make.size.equalTo(60)
        }
        logoImageView.layer.borderColor = UIColor.Pallete.gray.cgColor
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.cornerRadius = 30
        // (60 + 5 + 5) / 2 = 35
        layer.cornerRadius = 35
        
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(10)
            make.centerY.equalTo(logoImageView)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        action()
    }
}
