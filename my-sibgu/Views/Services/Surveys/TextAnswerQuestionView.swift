//
//  TextAnswerQuestionView.swift
//  my-sibgu
//
//  Created by art-off on 17.01.2021.
//

import UIKit

class TextAnswerQuestionView: UIView {

    var question: Question!
    var textAnswer: String {
        answerTextView.text
    }
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.sibsuBlue
        return label
    }()
    
    private let necessarilyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let answerTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    
    private var answerViews: [AnswerView] = []
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    convenience init(question: Question) {
        self.init()

        set(question: question)
    }
    
    
    // MARK: - Setup Views
    private func setupViews() {
        self.addSubview(necessarilyLabel)
        necessarilyLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
        necessarilyLabel.text = "*"
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(10)
            make.trailing.equalTo(necessarilyLabel.snp.leading)
        }
        
        self.addSubview(answerTextView)
        answerTextView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.bottom.trailing.equalToSuperview().inset(10)
            make.height.equalTo(300)
        }
        answerTextView.layer.borderWidth = 1
        answerTextView.layer.borderColor = UIColor.black.cgColor
        answerTextView.layer.cornerRadius = 10
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 15
        self.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 4)
    }
    
    private func set(question: Question) {
        guard question.type == .textAnswer else {
            fatalError("OneAnswerSurveyView does not accept quesitons with \(question.type) type")
        }
        
        self.question = question
        
        nameLabel.text = question.name
        
        necessarilyLabel.isHidden = !question.necessarily
    }

}
