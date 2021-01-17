//
//  AnswerView.swift
//  my-sibgu
//
//  Created by art-off on 17.01.2021.
//

import UIKit

protocol AnswerViewDelegate {
    func selectedAnswer(with id: Int)
}

class AnswerView: UIView {
    
    private var delegate: AnswerViewDelegate?
    var answer: Answer!
    
    var isSelected = false {
        didSet {
            fillView.isHidden = !isSelected
        }
    }
    
    private let boxView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.black.cgColor
        return v
    }()
    
    private let fillView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    private let nameLabel: UILabel = {
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
    
    convenience init(answer: Answer, type: SelectAnswerQuestionViewType, delegate: AnswerViewDelegate) {
        self.init()
        
        self.delegate = delegate
        self.answer = answer
        self.set(type: type)
        nameLabel.text = answer.text
        fillView.isHidden = true
    }
    
//    // MARK: - Methods
//    func set(isSelected: Bool) {
//        fillView.isHidden = !isSelected
//    }
    
    
    // MARK: - Setup Views
    private func setupViews() {
        boxView.addSubview(fillView)
        fillView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        self.addSubview(boxView)
        boxView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.size.equalTo(24)
        }
        
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(24)
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(boxView.snp.trailing).offset(5)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        self.backgroundColor = .clear
    }
    
    private func set(type: SelectAnswerQuestionViewType) {
        if type == .one {
            boxView.layer.cornerRadius = 12 // 24 / 2 = 12
            fillView.layer.cornerRadius = 7 // (24 - 5 - 5) / 2 = 6
        } else if type == .many {
            boxView.layer.cornerRadius = 4
            fillView.layer.cornerRadius = 2
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.selectedAnswer(with: answer.id)
    }

}
