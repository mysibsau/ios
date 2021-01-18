//
//  SelectAnswerQuesionView.swift
//  my-sibgu
//
//  Created by art-off on 17.01.2021.
//

import UIKit

enum SelectAnswerQuestionViewType {
    case one
    case many
}

class SelectAnswerQuesionView: UIView {
    
    var questionType: SelectAnswerQuestionViewType!
    
    var question: Question!
    var selectedIds: Set<Int> = []
    
    
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
    
    private let answersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
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
    
    convenience init(question: Question, questionType: SelectAnswerQuestionViewType) {
        self.init()
        
        self.questionType = questionType
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
        
        self.addSubview(answersStackView)
        answersStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.bottom.trailing.equalToSuperview().inset(10)
        }
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 15
        self.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 4)
    }
    
    private func set(question: Question) {
        guard question.type != .textAnswer else {
            fatalError("OneAnswerSurveyView does not accept quesitons with \(question.type) type")
        }
        
        self.question = question
        
        nameLabel.text = question.name
        
        necessarilyLabel.isHidden = !question.necessarily
        
        for answer in question.answers {
            let answerView = AnswerView(answer: answer, type: questionType, delegate: self)
            answerViews.append(answerView)
            answersStackView.addArrangedSubview(answerView)
            answerView.widthAnchor.constraint(equalTo: answersStackView.widthAnchor).isActive = true
        }
    }

}

extension SelectAnswerQuesionView: AnswerViewDelegate {
    
    func selectedAnswer(with id: Int) {
        guard let tappedAnswerView = answerViews.filter({ $0.answer.id == id }).first else { return }
        
        if questionType == .one {
            if tappedAnswerView.isSelected {
                // Если она выбрана и была нажата - снимаем выбор со всех (с нее в том числе)
                selectedIds.removeAll()
                answerViews.forEach {
                    $0.isSelected = false
                }
            } else {
                // Если она была не выбрана - теперь выбрана
                selectedIds.removeAll()
                selectedIds.insert(id)
                answerViews.forEach {
                    $0.isSelected = false
                }
                tappedAnswerView.isSelected = true
            }
        } else if questionType == .many {
            if tappedAnswerView.isSelected {
                selectedIds.remove(id)
                tappedAnswerView.isSelected = false
            } else {
                selectedIds.insert(id)
                tappedAnswerView.isSelected = true
            }
        }
    }
    
}
