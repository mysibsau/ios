//
//  LibrarySearchViewController.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import UIKit

class LibrarySearchViewController: UIViewController {
    
    // MARK: Outlets
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let wrapView = UIView()
    private let textField = UITextField()
    private let goToTimetableButton = UIButton()
    
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
        let tableName = "Timetable"
        
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "nav.bar.title".localized(using: tableName))
        
        favoriteTitleLabel.text = "favorite".localized(using: tableName)
    }
    
    private func setFavorite(_ type: EntitiesType) {
//        favoriteStackView.removeAllArrangedSubviews()
//
//        let favorites = timetableService.getFavoritesFromLocal()
//
//        for favorite in favorites {
//            switch favorite {
//            case .group(let group):
//                let v = FavoriteTimetableElemView(name: group.name, id: group.id, type: .group)
//                v.delegate = self
//                favoriteStackView.addArrangedSubview(v)
//            case .professor(let professor):
//                let v = FavoriteTimetableElemView(name: professor.name, id: professor.id, type: .professor)
//                v.delegate = self
//                favoriteStackView.addArrangedSubview(v)
//            case .place(let place):
//                let v = FavoriteTimetableElemView(name: place.name, id: place.id, type: .place)
//                v.delegate = self
//                favoriteStackView.addArrangedSubview(v)
//            }
//        }
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // configure wrapView
        wrapView.addSubview(goToTimetableButton)
        goToTimetableButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(70)
        }
        
        wrapView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalTo(goToTimetableButton.snp.leading)
        }
        
        wrapView.backgroundColor = UIColor.Pallete.content
        textField.borderStyle = .none
        textField.placeholder = "Введите название группу"
        textField.font = UIFont.systemFont(ofSize: 14)
        goToTimetableButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        goToTimetableButton.addTarget(self, action: #selector(goToTimetableButtonTapped), for: .touchUpInside)
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
        
        goToTimetableButton.makeShadow(opacity: 0.2, radius: 2)
        goToTimetableButton.makeBorder()
        goToTimetableButton.backgroundColor = UIColor.Pallete.content
        goToTimetableButton.layer.cornerRadius = 10
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

    @objc private func goToTimetableButtonTapped() {
//        guard let group = filtredGroups.first else { return }
//        
//        showTimetable(forType: currType, withId: group.id, animated: true)
    }
    
    private func prepareForGoToTimetable(entityType: EntitiesType, id: Int) {
        textField.text = ""
    }
    
}

extension LibrarySearchViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        goToTimetableButton.makeShadow(opacity: 0.2, radius: 2)
        goToTimetableButton.makeBorder()
        
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
