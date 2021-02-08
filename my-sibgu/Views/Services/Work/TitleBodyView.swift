//
//  TitleBodyView.swift
//  my-sibgu
//
//  Created by art-off on 06.02.2021.
//

import UIKit

class TitleBodyView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    private let bodyView = UIView()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    convenience init(title: String, body: String) {
        self.init()
        
        titleLabel.text = title
        bodyLabel.text = body
    }
    
    
    // MARK: - Setup Views
    private func setupViews() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(bodyView)
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.trailing.leading.bottom.equalToSuperview()
        }
        
        bodyView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        bodyView.backgroundColor = UIColor.Pallete.content
        
        self.backgroundColor = UIColor.Pallete.background
        
        bodyView.layer.cornerRadius = 15
        bodyView.makeShadow(opacity: 0.3, radius: 3)
        bodyView.makeBorder()
    }

}

extension TitleBodyView {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        bodyView.makeShadow(opacity: 0.3, radius: 3)
        bodyView.makeBorder()
    }
    
}
