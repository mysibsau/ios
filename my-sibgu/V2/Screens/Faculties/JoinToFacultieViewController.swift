//
//  JoinToFacultieViewController.swift
//  my-sibgu
//
//  Created by Artem Rylov on 17.10.2021.
//

import UIKit
import SnapKit

class JoinToFacultieViewController: UIViewController {
    
    var unionId: Int!
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    
    private let navBar = UINavigationBar()
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        return stackView
    }()
    
    private let fioTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ФИО"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private let instituteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Институт"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private let groupTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Группа"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private let idVkTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ID в VK"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private let hobbyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Какие у вас увлечения?"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private let reasonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Почему хотите вступить?"
        textField.font = UIFont.systemFont(ofSize: 20)
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
        instituteTextField.placeholder = "institute".localized(using: tableName)
        groupTextField.placeholder = "group".localized(using: tableName)
        idVkTextField.placeholder = "vk.id".localized(using: tableName)
        hobbyTextField.placeholder = "hobby".localized(using: tableName)
        reasonTextField.placeholder = "reason".localized(using: tableName)
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
        
        if UserService().getCurrUser() == nil {
            addArrangedSubviewToStackView(view: fioTextField)
        }
        addArrangedSubviewToStackView(view: instituteTextField)
        addArrangedSubviewToStackView(view: groupTextField)
        addArrangedSubviewToStackView(view: idVkTextField)
        addArrangedSubviewToStackView(view: hobbyTextField)
        addArrangedSubviewToStackView(view: reasonTextField)
    }
    
    private func addArrangedSubviewToStackView(view: UIView) {
        let lineView = UIView()
        let wrapView = UIView()
        wrapView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        wrapView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
        lineView.backgroundColor = UIColor.Pallete.sibsuBlue
        
        stackView.addArrangedSubview(wrapView)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneAction() {
        guard
//            let fio = fioTextField.text, !fio.isEmpty,
            let institute = instituteTextField.text, !institute.isEmpty,
            let group = groupTextField.text, !group.isEmpty,
            let idVk = idVkTextField.text, !idVk.isEmpty,
            let hobby = hobbyTextField.text, !hobby.isEmpty,
            let reason = reasonTextField.text, !reason.isEmpty
        else {
            let alert = UIAlertController(title: "Не все поля заполнены",
                                         message: nil,
                                         preferredStyle: .alert)
            
            alert.addAction(.init(title: "Ок", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let fio: String
        if let currUser = UserService().getCurrUser() {
            fio = currUser.fio
        } else {
            guard let optFio = fioTextField.text, !optFio.isEmpty else {
                let alert = UIAlertController(title: "Не все поля заполнены",
                                             message: nil,
                                             preferredStyle: .alert)
                
                alert.addAction(.init(title: "Ок", style: .default, handler: nil))
                present(alert, animated: true)
                return
            }
            fio = optFio
        }
        
        ApiCampusService().postJoinToFaculty(
            facultyId: unionId,
            fio: fio,
            institute: institute,
            group: group,
            vk: idVk,
            hobby: hobby,
            reason: reason) { isDone in
            
            DispatchQueue.main.async {
                if isDone {
                    // TODO: Тут надо показать, что все норм
                    self.dismissVC()
                } else {
                    // MARK: TODO: Или тут надо показать что не все норм (показать алерт)
                    let alert = UIAlertController(title: "Проблемы с сервером, попробуйте позже",
                                                 message: nil,
                                                 preferredStyle: .alert)
                    
                    alert.addAction(.init(title: "Ок", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
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
