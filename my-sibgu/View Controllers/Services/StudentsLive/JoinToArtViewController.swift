//
//  JoinToArtViewController.swift
//  my-sibgu
//
//  Created by Artem Rylov on 08.08.2021.
//

import UIKit

class JoinToArtViewController: UIViewController {
    
    var artId: Int!
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    
    private let navBar = UINavigationBar()
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let fioTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ФИО"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Телефон"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private let idVkTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ID в VK"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private let experienceTextField: TextViewWithPlaceholder = {
        let textField = TextViewWithPlaceholder()
        textField.placeholder = "Опыт творческой деятельности"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.snp.makeConstraints { $0.height.equalTo(100) }
        return textField
    }()
    
    private let commentTextField: TextViewWithPlaceholder = {
        let textField = TextViewWithPlaceholder()
        textField.placeholder = "Коментарий"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.snp.makeConstraints { $0.height.equalTo(100) }
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
        let tableName = "StudentLife"
        
        setupNavigationItems()
        
        fioTextField.placeholder = "fio".localized(using: tableName)
        phoneTextField.placeholder = "phone".localized(using: tableName)
        idVkTextField.placeholder = "vk.id".localized(using: tableName)
        experienceTextField.placeholder = "experience".localized(using: tableName)
        commentTextField.placeholder = "comment".localized(using: tableName)
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
        let tableName = "StudentLife"
        
        let navItem = UINavigationItem(title: "join.title".localized(using: tableName))
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissVC))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Отправить", style: .done, target: self, action: #selector(doneAction))
        
        navBar.items = [navItem]
    }
    
    private func setupViews() {
        self.view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40 + 50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(contentView).offset(-40)
        }
        
        addArrangedSubviewToStackView(view: fioTextField)
        addArrangedSubviewToStackView(view: phoneTextField)
        addArrangedSubviewToStackView(view: idVkTextField)
        addArrangedSubviewToStackView(view: experienceTextField)
        addArrangedSubviewToStackView(view: commentTextField)
    }
    
    private func addArrangedSubviewToStackView(view: UIView) {
        let wrapView = UIView()
        wrapView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(view is UITextView ? 5 : 10)
        }
        
        wrapView.layer.cornerRadius = 5
        wrapView.makeBorder(color: UIColor.Pallete.sibsuBlue)
        
        stackView.addArrangedSubview(wrapView)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneAction() {
        guard
            let fio = fioTextField.text, !fio.isEmpty,
            let phone = phoneTextField.text, !phone.isEmpty,
            let idVk = idVkTextField.text, !idVk.isEmpty,
            let experience = experienceTextField.text, !experience.isEmpty,
            let comment = commentTextField.text, !comment.isEmpty
        else {
            let alert = UIAlertController(title: "Не все поля заполнены",
                                         message: nil,
                                         preferredStyle: .alert)
            
            alert.addAction(.init(title: "Ок", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
//        ApiCampusService().postJoinToUnion(
//            unionId: unionId,
//            fio: fio,
//            institute: institute,
//            group: group,
//            vk: idVk,
//            hobby: hobby,
//            reason: reason) { isDone in
//
//            DispatchQueue.main.async {
//                if isDone {
//                    // TODO: Тут надо показать, что все норм
//                    self.dismissVC()
//                } else {
//                    // MARK: TODO: Или тут надо показать что не все норм (показать алерт)
//                }
//            }
//        }
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
