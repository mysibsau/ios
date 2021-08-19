//
//  AuthViewController.swift
//  my-sibgu
//
//  Created by art-off on 09.02.2021.
//

import UIKit


protocol AuthViewControllerDelegate {
    func showMainModule()
}


class AuthViewController: UIViewController {
    
    var delegate: AuthViewControllerDelegate?
    
    private let userService = UserService()
    
    private let alertView = AlertView()
    private let activityIndicatorView = UIActivityIndicatorView()
    
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
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signInButton = UIButton()
    private let registrationButton = UIButton()
    
    private var checked = false {
        didSet { checkImageView.isHidden = !checked }
    }
    private let checkView = UIView()
    private let checkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .init(systemName: "checkmark")?.withTintColor(UIColor.Pallete.sibsuBlue)
        iv.isHidden = true
        iv.isUserInteractionEnabled = false
        return iv
    }()
    private let checkLabel = UrlTappableLabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupScrollView()
        
        setupEmblem()
        setupTextFields()
        setupCkeckSenment()
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
        textFieldsView.makeShadow(opacity: 0.2, radius: 6)
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
    
    private func setupCkeckSenment() {
        contentView.addSubview(checkView)
        checkView.snp.makeConstraints { make in
            make.size.equalTo(20)
//            make.top.equalTo(textFieldsView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        checkView.makeBorder(color: UIColor.Pallete.blackOrWhite, width: 1)
        checkView.backgroundColor = UIColor.Pallete.background
        checkView.layer.cornerRadius = 2
        
        checkView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(checkLabel)
        checkLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldsView.snp.bottom).offset(15)
            make.leading.equalTo(checkView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        checkLabel.numberOfLines = 0
        checkLabel.setTextWithUrls(text: "Принимаю какую то дич [Условия](https://mysibsau.ru/download/)")
        checkLabel.makeTappable()
        
        checkView.snp.makeConstraints { make in
            make.centerY.equalTo(checkLabel)
        }
        
        checkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectCheck)))
    }
    
    @objc
    private func didSelectCheck() {
        checked.toggle()
    }
    
    private func setupSignInButton() {
        contentView.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(checkLabel.snp.bottom).offset(20)
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
        registrationButton.addTarget(self, action: #selector(didTapSingIsAsGuestButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func didTapSignInButton() {
        guard checked else {
            let alert = UIAlertController(title: nil,
                                         message: "Поставьте согласие на пользовательское соглашение",
                                         preferredStyle: .alert)
            
            alert.addAction(.init(title: "Ок", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        guard
            let number = numberTextField.text, !number.isEmpty,
            let password = passwordTextFiled.text, !password.isEmpty
        else {
            showAlert(withText: "Заполните все поля")
            return
        }
        
        startActivityIndicator()
        userService.authUser(number: number, password: password) { user in
            guard user != nil else {
                DispatchQueue.main.async {
                    self.showAlert(withText: "Проблемы со входом")
                    self.stopActivityIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.showMainModule()
                self.stopActivityIndicator()
            }
        }
    }
    
    @objc
    private func didTapSingIsAsGuestButton() {
        guard checked else {
            let alert = UIAlertController(title: nil,
                                         message: "Поставьте согласие на пользовательское соглашение",
                                         preferredStyle: .alert)
            
            alert.addAction(.init(title: "Ок", style: .default, handler: nil))
            present(alert, animated: true)
            return
            return
        }
        
        userService.outCurrUser()
        delegate?.showMainModule()
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

extension AuthViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
    
}

extension AuthViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
    
}
