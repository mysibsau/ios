//
//  FAQView.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import UIKit


protocol FAQViewDelegate {
    func didTapToShowInfoOnQuestion(with id: Int)
}

class FAQView: UIView {
    
    var delegate: FAQViewDelegate?
    
    
    private var faq: FAQ!
    
    private var isAddInfoMode = false

    private let containerView = UIView()
    
    let questionLabel: CopyableLabel = {
        let label = CopyableLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    private let answerLabel: UrlTappableLabel = {
        let label = UrlTappableLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    convenience init(faq: FAQ) {
        self.init()
        self.faq = faq
        self.questionLabel.text = faq.question
        self.answerLabel.makeUrlTappable()
        self.answerLabel.setTextWithUrls(text: faq.answer)
        
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
        containerView.makeShadow()
        containerView.makeBorder()
        
        containerView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(15)
        }
        
        answerLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.questionLabel.snp.removeConstraints()
        self.answerLabel.snp.removeConstraints()
        
        if isAddInfoMode {
            questionLabel.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalToSuperview().inset(15)
            }
            
            self.answerLabel.isHidden = true
            isAddInfoMode = false
        } else {
            self.questionLabel.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview().inset(15)
            }
            
            if !containerView.contains(answerLabel) {
                containerView.addSubview(answerLabel)
            }
            
            self.answerLabel.snp.makeConstraints { make in
                make.top.equalTo(questionLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(15)
                make.trailing.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-15)
            }
            
            self.answerLabel.isHidden = false
            isAddInfoMode = true
            delegate?.didTapToShowInfoOnQuestion(with: faq.id)
        }
        
        self.layoutIfNeeded()
    }
    
    @objc
    private func updateText() {
        //let tableName = "FAQ"
        
        
    }

}

extension FAQView {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        containerView.makeShadow()
        containerView.makeBorder()
    }
    
}
