//
//  DepartmentView.swift
//  my-sibgu
//
//  Created by art-off on 28.12.2020.
//

import UIKit
import SnapKit

// MARK: TODO: Сделай функцию для label чтобы она выдавала лабель с такими настройками как надо а не прописывать эти св-ва миллион раз

class DepartmentView: UIView {
    
    private var department: Institute.Department!
    
    private var isAddInfoMode = false

    private let containerView = UIView()
    
    private let addInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    let nameLabel: CopyableLabel = {
        let label = CopyableLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Pallete.sibsuBlue
        return view
    }()
    
    let headNameLabel: CopyableLabel = {
        let label = CopyableLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    let addressLabel: CopyableLabel = {
        let label = CopyableLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    let phoneLabel: CopyableLabel = {
        let label = CopyableLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    let emailLabel: CopyableLabel = {
        let label = CopyableLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    
    convenience init(department: Institute.Department) {
        self.init()
        self.department = department
        self.nameLabel.text = department.name
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.backgroundColor = UIColor.Pallete.content
        containerView.layer.cornerRadius = 15
//        containerView.makeShadow(color: .black, opacity: 0.3, shadowOffser: .zero, radius: 4)
        containerView.makeShadow()
        containerView.makeBorder()
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(15)
        }
        
        
        addInfoStackView.addArrangedSubview(headNameLabel)
        addInfoStackView.addArrangedSubview(addressLabel)
        addInfoStackView.addArrangedSubview(phoneLabel)
        addInfoStackView.addArrangedSubview(emailLabel)
        
        lineView.isHidden = true
        addInfoStackView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameLabel.snp.removeConstraints()
        self.lineView.snp.removeConstraints()
        self.addInfoStackView.snp.removeConstraints()
        
        if isAddInfoMode {
            nameLabel.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalToSuperview().inset(15)
            }
            
            if containerView.contains(lineView) {
                lineView.removeFromSuperview()
            }
            if containerView.contains(addInfoStackView) {
                addInfoStackView.removeFromSuperview()
            }
            
            self.addInfoStackView.isHidden = true
            isAddInfoMode = false
        } else {
            self.nameLabel.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview().inset(15)
            }
            
            if !containerView.contains(lineView) {
                containerView.addSubview(lineView)
            }
            if !containerView.contains(addInfoStackView) {
                containerView.addSubview(addInfoStackView)
            }
            
            self.addInfoStackView.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-15)
            }
            
            self.lineView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(15)
                make.top.bottom.equalTo(addInfoStackView)
                make.width.equalTo(3)
            }
            
            self.addInfoStackView.isHidden = false
            self.lineView.isHidden = false
            isAddInfoMode = true
        }
        
        self.layoutIfNeeded()
    }
    
    @objc
    private func updateText() {
        let tableName = "Institutes"
        
        self.headNameLabel.attributedText = attrStringWithBoldTextBeforeColon(text: "\("head".localized(using: tableName)): \(department.leaderName)")
        self.addressLabel.attributedText = attrStringWithBoldTextBeforeColon(text: "\("address".localized(using: tableName)): \(department.address)")
        self.phoneLabel.attributedText = attrStringWithBoldTextBeforeColon(text: "\("phone".localized(using: tableName)): \(department.phone ?? "-")")
        self.emailLabel.attributedText = attrStringWithBoldTextBeforeColon(text: "\("email".localized(using: tableName)): \(department.email ?? "-")")
    }
    
    private func attrStringWithBoldTextBeforeColon(text: String) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        
        let regex = try! NSRegularExpression(pattern: ".*:")
        guard let range = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))?.range else {
            return attrString
        }
        
        attrString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: range)
        
        return attrString
    }

}

extension DepartmentView {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        containerView.makeShadow()
        containerView.makeBorder()
    }
    
}
