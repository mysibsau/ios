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
    
    private lazy var fioTitleLabel = getUserTitleLabel()
    private lazy var groupTitleLabel = getUserTitleLabel()
    private lazy var averageRateTitleLabel = getUserTitleLabel()
    private lazy var studentIdTitleLabel = getUserTitleLabel()
    private lazy var performanceTitleLabel = getUserTitleLabel()
    
    private lazy var fioLabel = getUserLabel()
    private lazy var groupLabel = getUserLabel()
    private lazy var averageRateLabel = getUserLabel()
    private lazy var studentIdLabel = getUserLabel()
    private lazy var attestationLabel = getUserLabel()
    private lazy var marksLabel = getUserLabel()
    
    private lazy var fioView = getWrapView()
    private lazy var groupView = getWrapView()
    private lazy var averageRateView = getWrapView()
    private lazy var studentIdView = getWrapView()
    private lazy var performanceView = getWrapView()
    private lazy var performanceStackView = getPerformanceStackView()
    private lazy var attestationView = UIView()
    private lazy var marksView = UIView()
    
    private let separateView = UIView()
    
    
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
    
    private func getPerformanceStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
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
        
        user = userService.getCurrUser()
        
        if user == nil {
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

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        stackView.addArrangedSubview(getFioSegment())
        stackView.addArrangedSubview(getGroupAndAverageRateSegment())
        stackView.addArrangedSubview(getStudentIdSegment())
        stackView.addArrangedSubview(getPerformanceSegment())
        
        fioTitleLabel.text = "ФИО"
        fioLabel.text = user?.fio
        
        groupTitleLabel.text = "Группа"
        groupLabel.text = user?.group
        
        averageRateTitleLabel.text = "Средний балл"
        averageRateLabel.text = String(user?.averageRating ?? 0)
        
        studentIdTitleLabel.text = "Номер зачетки"
        studentIdLabel.text = user?.zachotka
        
        performanceTitleLabel.text = "Успеваемость"
    }
    
    private func getFioSegment() -> UIView {
        let fioSegment = getViewWithTitleAndInfo(
            titleLabel: fioTitleLabel,
            infoView: fioView,
            infoLabel: fioLabel
        )
        return fioSegment
    }
    
    private func getGroupAndAverageRateSegment() -> UIView {
        let groupSegment = getViewWithTitleAndInfo(
            titleLabel: groupTitleLabel,
            infoView: groupView,
            infoLabel: groupLabel
        )
        let averageRateSegment = getViewWithTitleAndInfo(
            titleLabel: averageRateTitleLabel,
            infoView: averageRateView,
            infoLabel: averageRateLabel
        )
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 20
        
        hStackView.addArrangedSubview(groupSegment)
        hStackView.addArrangedSubview(averageRateSegment)
        
        return hStackView
    }
    
    private func getStudentIdSegment() -> UIView {
        let studentIdSegment = getViewWithTitleAndInfo(
            titleLabel: studentIdTitleLabel,
            infoView: studentIdView,
            infoLabel: studentIdLabel
        )
        return studentIdSegment
    }
    
    private func getPerformanceSegment() -> UIView {
        attestationView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        attestationView.addSubview(attestationLabel)
        attestationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        let attestationArrow = getArrowImage()
        attestationView.addSubview(attestationArrow)
        attestationArrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.size.equalTo(22)
        }
        
        attestationLabel.text = "Аттестация"

        marksView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        marksView.addSubview(marksLabel)
        marksLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        let marksArrow = getArrowImage()
        marksView.addSubview(marksArrow)
        marksArrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.size.equalTo(22)
        }
        
        separateView.snp.makeConstraints { make in
            make.height.equalTo(0.3)
        }
        separateView.backgroundColor = UIColor.Pallete.gray
        
        marksLabel.text = "Оценки"
        
        performanceStackView.addArrangedSubview(attestationView)
        performanceStackView.addArrangedSubview(separateView)
        performanceStackView.addArrangedSubview(marksView)
        performanceStackView.clipsToBounds = true
        
        performanceView.addSubview(performanceStackView)
        performanceStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let performanceSegment = getViewWithTitleAndInfo(
            titleLabel: performanceTitleLabel,
            infoView: performanceView
        )
        
        let attestationGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapToAttestation))
        let marksGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapToMarks))
        
        attestationView.addGestureRecognizer(attestationGestureRecognizer)
        marksView.addGestureRecognizer(marksGestureRecognizer)
        
        return performanceSegment
    }
    
    private func getArrowImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.Pallete.sibsuBlue
        return imageView
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
        
        numberTextField.placeholder = "number".localized(using: tableName)
        passwordTextFiled.placeholder = "password".localized(using: tableName)
        signInButton.setTitle("sign.in".localized(using: tableName), for: .normal)
        descriptionLabel.text = "sign.in.description".localized(using: tableName)
        
        fioTitleLabel.text = "fio".localized(using: tableName)
        groupTitleLabel.text = "group".localized(using: tableName)
        averageRateTitleLabel.text = "average.rate".localized(using: tableName)
        studentIdTitleLabel.text = "student.id".localized(using: tableName)
        
        performanceTitleLabel.text = "performance".localized(using: tableName)
        attestationLabel.text = "attestation".localized(using: tableName)
        marksLabel.text = "marks".localized(using: tableName)
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
                self.setupUserViews()
            }
        }
    }
    
    @objc
    private func didTapToMarks() {
        let vc = MarksViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func didTapToAttestation() {
        let vc = AttestaionViewController()
        navigationController?.pushViewController(vc, animated: true)
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
        
        fioView.makeBorder()
        fioView.makeShadow()
        
        groupView.makeBorder()
        groupView.makeShadow()
        
        studentIdView.makeBorder()
        studentIdView.makeShadow()
        
        averageRateView.makeBorder()
        averageRateView.makeShadow()
        
        performanceView.makeBorder()
        performanceView.makeShadow()
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
