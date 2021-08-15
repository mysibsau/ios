//
//  CornerImageWithTitleView.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.08.2021.
//

import UIKit

class CornerImageWithTitleView: UIView {

    let imageView = UIImageView()
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public init(text: String, imageName: String) {
        self.init()
        self.label.text = text
        self.imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.Pallete.content
        self.layer.cornerRadius = 20
        makeShadow()
        makeBorder()
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.Pallete.sibsuGreen
        
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.Pallete.sibsuBlue
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
}
