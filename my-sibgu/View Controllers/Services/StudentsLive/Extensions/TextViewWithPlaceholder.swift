//
//  TextViewWithPlaceholder.swift
//  my-sibgu
//
//  Created by Artem Rylov on 08.08.2021.
//

import UIKit
import SnapKit

class TextViewWithPlaceholder: UITextView, UITextViewDelegate {
    
    private let placeholderLabel = UILabel()
    private var topConstraint: Constraint?
    
    var placeholder: String? {
        set { placeholderLabel.text = newValue }
        get { placeholderLabel.text }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
            topConstraint?.update(offset: font!.pointSize / 2)
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
        showPlaceholderIfNedded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        showPlaceholderIfNedded()
    }
    
    private func showPlaceholderIfNedded() {
        if !subviews.contains(placeholderLabel) {
            setupPlaceholderLabel()
        }
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    private func setupPlaceholderLabel() {
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            topConstraint = make.top.equalToSuperview().constraint
        }
        placeholderLabel.textColor = .systemGray3
        placeholderLabel.font = font
        placeholderLabel.textAlignment = .left
    }
}
