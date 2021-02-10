//
//  AuthViewController.swift
//  my-sibgu
//
//  Created by art-off on 09.02.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let emblemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "main_logo")
        return imageView
    }()
    
    private let textFieldsView = UIView()
    private let numberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        return imageView
    }()
    private var numberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Номер зачетки"
        return textField
    }()
    private let passwordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "key")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        return imageView
    }()
    private var passwordTextFiled: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        return textField
    }()
    
    private let signInButton = UIButton()
    private let registrationButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupScrollView()
        
        setupEmblem()
        setupTextFields()
        setupSignInButton()
        setupSingInAsGuestButton()
        
        
        addGestureRecongizerToHideKeyboard()
        addHideShowKeyboardRecognizers()
    }
    
    // MARK: - Setup Views
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
    
    private func setupEmblem() {
        contentView.addSubview(emblemImageView)
        emblemImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(130)
        }
    }
    
    private func setupTextFields() {
        contentView.addSubview(textFieldsView)
        textFieldsView.snp.makeConstraints { make in
            make.top.equalTo(emblemImageView.snp.bottom).offset(65)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        textFieldsView.backgroundColor = UIColor.Pallete.content
        textFieldsView.layer.cornerRadius = 15
        textFieldsView.makeShadow()
        textFieldsView.makeBorder()
        
        
        textFieldsView.addSubview(numberImageView)
        numberImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(8)
            make.height.equalTo(24)
            make.width.equalTo(35)
        }
        
        textFieldsView.addSubview(numberTextField)
        numberTextField.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(numberImageView.snp.trailing)
            make.height.equalTo(40)
        }
        
        let lineView = UIView()
        textFieldsView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(numberTextField.snp.bottom)
        }
        lineView.backgroundColor = .gray
        
        textFieldsView.addSubview(passwordImageView)
        passwordImageView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(8)
            make.height.equalTo(24)
            make.width.equalTo(35)
        }
        
        textFieldsView.addSubview(passwordTextFiled)
        passwordTextFiled.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.trailing.equalToSuperview()
            make.leading.equalTo(passwordImageView.snp.trailing)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        passwordTextFiled.isUserInteractionEnabled = true
    }
    
    private func setupSignInButton() {
        contentView.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldsView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        signInButton.setTitle("Войти", for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        signInButton.backgroundColor = UIColor.Pallete.sibsuBlue
        signInButton.layer.cornerRadius = 10
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
    }
    
    private func setupSingInAsGuestButton() {
        contentView.addSubview(registrationButton)
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        registrationButton.setTitle("Войти как гость", for: .normal)
        registrationButton.setTitleColor(UIColor.Pallete.gray, for: .normal)
        registrationButton.addTarget(self, action: #selector(didTapRegistrationButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func didTapSignInButton() {
        print("helk")
    }
    
    @objc
    private func didTapRegistrationButton() {
        print(";;;;;;")
    }
    
    private func addGestureRecongizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }

    
    // MARK: - Methods For Notification
    private func addHideShowKeyboardRecognizers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardWillHide(notification:NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
}
