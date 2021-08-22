//
//  ProfileViewController.swift
//  my-sibgu
//
//  Created by art-off on 18.01.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let userService = UserService()
    
    private var user: User?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
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
    
    private func getUserLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }
    
    private func getUserTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.Pallete.sibsuBlue
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }
    
    private func getWrapView() -> UIView {
        let view = UIView()
        view.makeShadow()
        view.makeBorder()
        view.layer.cornerRadius = 10
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
        
        updateText()
    }
    
    enum ViewType {
        case titleWithText(String, String)
        case twoTitleWithTwoText(String, String, String, String)
        case titleWithButtonsBlock(String, [(String, () -> Void)])
    }
    
    private func setupModels(views: [ViewType]) {
        stackView.removeAllArrangedSubviews()
        if !contentView.subviews.contains(stackView) {
            contentView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(20)
            }
        }
        for viewType in views {
            switch viewType {
            case .titleWithText(let title, let text):
                stackView.addArrangedSubview(titleWithText(title: title, text: text))
            case .twoTitleWithTwoText(let title1, let text1, let title2, let text2):
                stackView.addArrangedSubview(titlesWithTexts(models: [(title1, text1), (title2, text2)]))
            case .titleWithButtonsBlock(let title, let buttons):
                stackView.addArrangedSubview(titleWithButtons(title: title, buttons: buttons))
            }
        }
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
    private func setupUserViews(tableName: String) {
        guard let user = user else { return }
        
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        
        setupModels(views: [
            .titleWithText("fio".localized(using: tableName), user.fio),
            .twoTitleWithTwoText("group".localized(using: tableName),
                                 user.group,
                                 "average.rate".localized(using: tableName),
                                 String(user.averageRating)),
            .titleWithText("student.id".localized(using: tableName), user.zachotka),
            .titleWithButtonsBlock("performance".localized(using: tableName), [
                ("attestation".localized(using: tableName), {
                    let vc = AttestaionViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }),
                ("marks".localized(using: tableName), {
                    let vc = MarksViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            ]),
            .titleWithButtonsBlock("help".localized(using: tableName), [
                ("my.question".localized(using: tableName), {
                    let vc = FAQViewController()
                    vc.mode = .myQuestions
                    self.navigationController?.pushViewController(vc, animated: true)
                }),
                ("FAQ", {
                    let vc = FAQViewController()
                    vc.mode = .faq
                    self.navigationController?.pushViewController(vc, animated: true)
                }),
                ("feedback".localized(using: tableName), {
                    self.navigationController?.pushViewController(SurveyViewController(), animated: true)
                }),
                ("user.agreement".localized(using: tableName), {
                    URL(string: "https://mysibsau.ru/user-agreement/")?.openIfCan()
                })
            ])
        ])
    }
    
    private func titleWithButtons(title: String, buttons: [(test: String, action: () -> Void)]) -> UIView {
        let titleLabel = getUserTitleLabel()
        let wrapView = getWrapView()
        
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 0
        vStackView.clipsToBounds = true
        
        for (index, buttonModel) in buttons.enumerated() {
            let view = TappableView()
            let label = getUserLabel()
            let arrow = getArrowImage()
            
            view.addSubview(label)
            view.addSubview(arrow)
            
            view.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            label.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.centerY.equalToSuperview()
            }
            arrow.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
                make.size.equalTo(22)
            }
            
            label.text = buttonModel.test
            view.action(buttonModel.action)
            view.isUserInteractionEnabled = true
            
            vStackView.addArrangedSubview(view)
            
            if index != buttons.count - 1 {
                let separator = UIView()
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                }
                separator.backgroundColor = UIColor.Pallete.gray
                vStackView.addArrangedSubview(separator)
            }
        }
        
        wrapView.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = title
        
        return getViewWithTitleAndInfo(titleLabel: titleLabel,
                                       infoView: wrapView)
    }
    
    private func getArrowImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.Pallete.sibsuBlue
        return imageView
    }
    
    private func titlesWithTexts(models: [(title: String, text: String)]) -> UIView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 20
        
        for model in models {
            hStackView.addArrangedSubview(titleWithText(title: model.title, text: model.text))
        }
        
        return hStackView
    }
    
    private func titleWithText(title: String, text: String) -> UIView {
        let view = UIView()
        let titleLabel = getUserTitleLabel()
        let textView = getWrapView()
        let textLabel = getUserLabel()
        
        view.addSubview(titleLabel)
        view.addSubview(textView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        textView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        titleLabel.text = title
        textLabel.text = text
        
        return view
    }
    
    private func getViewWithTitleAndInfo(titleLabel: UILabel, infoView: UIView, infoLabel: UILabel? = nil) -> UIView {
        let view = UIView()
        view.addSubview(titleLabel)
        view.addSubview(infoView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        infoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        if let infoLabel = infoLabel {
            infoView.addSubview(infoLabel)
            infoLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(12)
            }
        }
        
        return view
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
        
        user = userService.getCurrUser()

        if user == nil {
            setupSignInView()
            numberTextField.placeholder = "number".localized(using: tableName)
            passwordTextFiled.placeholder = "password".localized(using: tableName)
            signInButton.setTitle("sign.in".localized(using: tableName), for: .normal)
            descriptionLabel.text = "sign.in.description".localized(using: tableName)
        } else {
            setupUserViews(tableName: tableName)
        }
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
        userService.authUser(number: number, password: password) { user in
            guard user != nil else {
                DispatchQueue.main.async {
                    self.showAlert(withText: "Проблемы со входом")
                    self.stopActivityIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.user = user
                self.stopActivityIndicator()
                self.updateText()
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
        super.traitCollectionDidChange(previousTraitCollection)
        
        textFieldsView.makeBorder()
        textFieldsView.makeShadow(opacity: 0.2, radius: 6)
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
