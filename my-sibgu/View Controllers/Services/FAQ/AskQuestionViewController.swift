//
//  AskQuestionViewController.swift
//  my-sibgu
//
//  Created by art-off on 04.02.2021.
//

import UIKit

class AskQuestionViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let navBar = UINavigationBar()
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let alertView = AlertView()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    private let questionTextView: UITextView = {
        let textField = UITextView()
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()

    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupScrollView()
        
        setupViews()
        
        setupNavigationItems()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:UIResponder.keyboardWillHideNotification, object: nil)
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText() {
        let tableName = "FAQ"
        
        titleLabel.text = "write.answer".localized(using: tableName)
        setupNavigationItems()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        // убираем полосы прокрутки
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view)
        }
    }
    
    private func setupNavigationItems() {
        let tableName = "FAQ"
        
        let navItem = UINavigationItem(title: "ask".localized(using: tableName))
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "close".localized(using: tableName), style: .plain, target: self, action: #selector(dismissVC))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "send".localized(using: tableName), style: .done, target: self, action: #selector(doneAction))
        
        navBar.items = [navItem]
    }
    
    private func setupViews() {
        self.view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40 + 30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        titleLabel.text = "Введите вопрос"
        
        contentView.addSubview(questionTextView)
        questionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(100)
        }
        questionTextView.layer.cornerRadius = 10
        questionTextView.makeBorder(color: .gray)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneAction() {
        guard let question = questionTextView.text, !question.isEmpty else {
            self.showAlert(withText: "Введите вопрос")
            return
        }
        
        RequestServise.shared.performAndReturnStatus(
            FAQCreateRequest(question: question, theme: "general", isPublic: false)) { isFine in
            guard isFine else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.showAlert(withText: "Проблемы с отправкой")
                }
                return
            }
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                self.dismissVC()
            }
        }
    }
    
    // MARK: - Methods For Notification -
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

}

extension AskQuestionViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
    
}

extension AskQuestionViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
    
}
