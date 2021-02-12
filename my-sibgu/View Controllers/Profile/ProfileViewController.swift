//
//  ProfileViewController.swift
//  my-sibgu
//
//  Created by art-off on 18.01.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let authService = AuthService()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let alertView = AlertView()
    private let activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: Auth
    private let descriptionLabel = UILabel()
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
    
    // MARK: User
    private lazy var fioLabel = getUserLabel()
    private lazy var groupLabel = getUserLabel()
    private lazy var averageRateLabel = getUserLabel()
    private lazy var studentIdLabel = getUserLabel()
    
    private lazy var fioView = getWrapView()
    private lazy var groupView = getWrapView()
    private lazy var averageRateView = getWrapView()
    private lazy var studentIdView = getWrapView()
    
    private func getUserLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }
    
    private func getWrapView() -> UIView {
        let view = UIView()
        view.makeShadow()
        view.makeBorder()
        view.backgroundColor = UIColor.Pallete.content
        return view
    }
    
    
    // MARK: - Life Circle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background

        setupNavBar()
        addSettiongsBarButton()
        
        setupScrollView()
        
        addGestureRecongizerToHideKeyboard()
        addHideShowKeyboardRecognizers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if authService.getCurrUser() == nil {
            setupSignInView()
        } else {
            setupUserViews()
        }
        
        self.updateText()
    }
    
    // MARK: - Setup Views
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    private func addSettiongsBarButton() {
        let gearImage = UIImage(systemName: "gear")
        let barButton = UIBarButtonItem(image: gearImage, style: .done, target: self, action: #selector(showSettiongs))
        barButton.tintColor = UIColor.Pallete.gray
        navigationItem.rightBarButtonItem = barButton
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
    
    // MARK: Sign In
    private func setupSignInView() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        
        setupTextFields()
        setupSignInButton()
        setupDescriptionLabel()
    }
    
    private func setupTextFields() {
        contentView.addSubview(textFieldsView)
        textFieldsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(170)
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
    
    private func setupSignInButton() {
        contentView.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldsView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
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
    
    private func setupDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = UIColor.Pallete.gray
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        descriptionLabel.text = "Войдите в профиль, чтобы иметь дополнительные возможности"
    }
    
    // MARK: User
    private func setupUserViews() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        fioLabel.removeFromSuperview()
        groupLabel.removeFromSuperview()
        studentIdLabel.removeFromSuperview()
        averageRateLabel.removeFromSuperview()
        numberTextField.text?.removeAll()
        passwordTextFiled.text?.removeAll()

        fioView.addSubview(fioLabel)
        fioLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        groupView.addSubview(groupLabel)
        groupLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        studentIdView.addSubview(studentIdLabel)
        studentIdLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        averageRateView.addSubview(averageRateLabel)
        averageRateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20

        stackView.addArrangedSubview(fioView)
        stackView.addArrangedSubview(groupView)
        fioLabel.text = "sldkjfals;dkjf"
        groupLabel.text = "sldkjf"

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Actions
    @objc
    private func showSettiongs() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func updateText() {
        let tableName = "Profile"
        
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "navBarTitle".localized(using: tableName))
        
        numberTextField.placeholder = "number".localized(using: tableName)
        passwordTextFiled.placeholder = "password".localized(using: tableName)
        signInButton.setTitle("sign.in".localized(using: tableName), for: .normal)
        descriptionLabel.text = "sign.in.description".localized(using: tableName)
    }
    
    @objc
    private func didTapSignInButton() {
        guard
            let number = numberTextField.text, !number.isEmpty,
            let password = passwordTextFiled.text, !password.isEmpty
        else {
            showAlert(withText: "Заполните все поля")
            return
        }
        
        startActivityIndicator()
        authService.authUser(number: number, password: password) { user in
            guard user != nil else {
                DispatchQueue.main.async {
                    self.showAlert(withText: "Проблемы со входом")
                    self.stopActivityIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                self.setupUserViews()
            }
        }
    }
    
    // MARK: - Notification
    private func addGestureRecongizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
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

extension ProfileViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        textFieldsView.makeBorder()
        textFieldsView.makeShadow(opacity: 0.2, radius: 6)
        
        fioView.makeBorder()
        fioView.makeShadow()
        
        groupView.makeBorder()
        groupView.makeShadow()
        
        studentIdView.makeBorder()
        studentIdView.makeShadow()
        
        averageRateView.makeBorder()
        averageRateView.makeShadow()
    }
    
}

extension ProfileViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
    
}

extension ProfileViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
    
}
