//
//  JoinToUnionViewController.swift
//  my-sibgu
//
//  Created by art-off on 06.01.2021.
//

import UIKit
import SnapKit

class JoinToUnionViewController: UIViewController {
    
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
        
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        
        setupViews()
        
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
        let navItem = UINavigationItem(title: "Заявка на вступление")

        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        
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
        lineView.backgroundColor = Colors.sibsuBlue
        
        stackView.addArrangedSubview(wrapView)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneAction() {
        guard
            let fio = fioTextField.text, !fio.isEmpty,
            let institute = instituteTextField.text, !institute.isEmpty,
            let group = groupTextField.text, !group.isEmpty,
            let idVk = idVkTextField.text, !idVk.isEmpty,
            let hobby = hobbyTextField.text, !hobby.isEmpty,
            let reason = reasonTextField.text, !reason.isEmpty
        else {
            // TODO: Показывать алект, что не все заполнили
            return
        }
        
        ApiCampusService().postJoinToUnion(
            unionId: unionId,
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
                    // TODO: Или тут надо показать что не все норм (показать алерт)
                }
            }
        }
    }

}
