//
//  LibrarySearchViewController.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import UIKit

class LibrarySearchViewController: UIViewController {
    
    private let libraryService = LibraryService()
    
    // MARK: Outlets
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let wrapView = UIView()
    private let textField = UITextField()
    private let goToButton = UIButton()
    
    private let favoriteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    private let favoriteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Private UI
    private let alertView = AlertView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupScrollView()
        setupTextFieldAndButton()
        
        configureNabBar()
        setupFavoriteStackView()
        configurateSearchViews()
        addRecognizerToHideKeyboard()
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText() {
        let tableName = "Library"
        
        self.navigationItem.setLeftTitle(title: "nav.bar.title".localized(using: tableName))
        
        favoriteTitleLabel.text = "last".localized(using: tableName)
    }
    
    private func setLast() {
        favoriteStackView.removeAllArrangedSubviews()
        
        
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
    
    private func setupTextFieldAndButton() {
        // add wrapView to contentView
        contentView.addSubview(wrapView)
        wrapView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // configure wrapView
        wrapView.addSubview(goToButton)
        goToButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(70)
        }
        
        wrapView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalTo(goToButton.snp.leading)
        }
        
        wrapView.backgroundColor = UIColor.Pallete.content
        textField.borderStyle = .none
        textField.placeholder = "Введите название группу"
        textField.font = UIFont.systemFont(ofSize: 14)
        goToButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        goToButton.addTarget(self, action: #selector(goToButtonTapped), for: .touchUpInside)
    }
    
    private func setupFavoriteStackView() {
        contentView.addSubview(favoriteTitleLabel)
        favoriteTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(wrapView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(favoriteStackView)
        favoriteStackView.snp.makeConstraints { make in
            make.top.equalTo(favoriteTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func configurateSearchViews() {
        wrapView.makeShadow()
        wrapView.makeBorder()
        wrapView.layer.cornerRadius = 10
        
        goToButton.makeShadow(opacity: 0.2, radius: 2)
        goToButton.makeBorder()
        goToButton.backgroundColor = UIColor.Pallete.content
        goToButton.layer.cornerRadius = 10
    }
    
    private func configureNabBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    // MARK: - Activity
    private func addRecognizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func goToButtonTapped() {
        guard let searchText = textField.text, !searchText.isEmpty else { return }
        
        startActivityIndicator()
        
        libraryService.getBooks(by: searchText) { result in
            DispatchQueue.main.async {
                guard let result = result else {
                    self.stopActivityIndicator()
                    self.showNetworkAlert()
                    return
                }
                
                let vc = LibraryPageViewController()
                vc.digitalBooks = result.0
                vc.physicalBooks = result.1
                self.navigationController?.pushViewController(vc, animated: true)
                self.stopActivityIndicator()
            }
        }
    }
    
}

extension LibrarySearchViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        goToButton.makeShadow(opacity: 0.2, radius: 2)
        goToButton.makeBorder()
        
        wrapView.makeShadow()
        wrapView.makeBorder()
    }
    
}

extension LibrarySearchViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicator
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return view
    }
    
}

extension LibrarySearchViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        return view
    }
    
    func alertingAlertView() -> AlertView {
        return alertView
    }
    
}
