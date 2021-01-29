//
//  FavoriteTimetableElemView.swift
//  my-sibgu
//
//  Created by art-off on 29.01.2021.
//

import UIKit

protocol FavoriteTimetableElemViewDelegate {
    func didTapToDeleteFavorite(with id: Int)
    func didTapToFavorite(with id: Int)
}

class FavoriteTimetableElemView: UIView {
    
    var delegate: FavoriteTimetableElemViewDelegate?
    var objectId: Int!
    var objectName: String!
    
    let titleLabel = UILabel()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    convenience init(name: String, id: Int) {
        self.init()
        objectId = id
        objectName = name
        
        titleLabel.text = objectName
    }
    
    
    private func setupViews() {
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(button.snp.leading)
        }
        
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        self.backgroundColor = UIColor.Pallete.content
        self.layer.cornerRadius = 10
        self.makeShadow()
        self.makeBorder()
    }
    
    @objc
    private func didTapButton() {
        delegate?.didTapToDeleteFavorite(with: objectId)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTapToFavorite(with: objectId)
    }

}

extension FavoriteTimetableElemView {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.makeShadow()
        self.makeBorder()
    }
    
}
