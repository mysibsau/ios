//
//  SettingsViewController.swift
//  my-sibgu
//
//  Created by art-off on 18.01.2021.
//

import UIKit
import SnapKit


protocol SettingsViewControllerDelegate {
    func showAuthModule()
}


private let cellId = "LanguageCell"

class SettingsViewController: UIViewController {
    
    private let authService = AuthService()
    
    // MARK: - Properties
    private var languages: [(identifier: String, displayName: String, isCurrent: Bool)] = []
    
    
    // MARK: - Language UI
    private lazy var languageLabel = _titleLabel()
    
    private let languagesTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    private let shadowViewLanguage = UIView()
    
    private lazy var languagesDescriptionLabel = _descriptionLabel()
    
    // MARK: - Theme UI
    private lazy var themeLabel = _titleLabel()
    
    private let themeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Системное*", "Светлое", "Темное"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    private let shadowViewTheme = UIView()
    
    private lazy var themeDescriptionLabel = _descriptionLabel()
    
    // MARK: - Out Button
    private let outButton = UIButton()
    
    
    // MARK: - UI Helper
    private func _titleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.Pallete.sibsuBlue
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }
    
    private func _descriptionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.Pallete.gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }
    
    
    // MARK: - Life Circle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Pallete.background
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        setupLanguageTableView()
        setupThemeSegmentedControl()
        
        if authService.getCurrUser() != nil {
            setupOutButton()
        }
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    // MARK: - Sutup Views
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    private func setupLanguageTableView() {
        languages.append(("", "Системный*", false))
        let identifiers = Localize.availableLanguages()
        for identifier in identifiers {
            languages.append((identifier, Localize.displayName(for: identifier), false))
        }
        
        // выставляем какой язык текущий
        if Localize.languageIsSystem {
            languages[0].isCurrent = true
        } else {
            let currLanguageIndex = languages.firstIndex { $0.identifier == Localize.currentLanguage }!
            languages[currLanguageIndex].isCurrent = true
        }
        
        languagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        languagesTableView.reloadData()
        
        
        view.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        // Добавление таблицы
        shadowViewLanguage.addSubview(languagesTableView)
        languagesTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        languagesTableView.dataSource = self
        languagesTableView.delegate = self
        languagesTableView.isScrollEnabled = false
        languagesTableView.backgroundColor = UIColor.Pallete.content
        
        view.addSubview(shadowViewLanguage)
        shadowViewLanguage.snp.makeConstraints { make in
            make.top.equalTo(languageLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(UITableViewCell().frame.height * 3 - 1) // -1 потому что внизу остается противная разделительная черта
        }
        shadowViewLanguage.makeBorder()
        languagesTableView.layer.cornerRadius = 10
        shadowViewLanguage.layer.cornerRadius = 10
        
        shadowViewLanguage.backgroundColor = UIColor.Pallete.content
        shadowViewLanguage.makeShadow(color: UIColor.Pallete.shadow, opacity: 0.3, shadowOffser: .zero, radius: 2)
        
        view.addSubview(languagesDescriptionLabel)
        languagesDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(languagesTableView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupThemeSegmentedControl() {
        // Заголовок над сменой темы
        view.addSubview(themeLabel)
        themeLabel.snp.makeConstraints { make in
            make.top.equalTo(languagesDescriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        
        // Добавил это теневое вью чтобы добавить тень к segmented control
        // но не могу изменить backgroundcolor у него на белый и поэтому тень плохая
        shadowViewTheme.addSubview(themeSegmentedControl)
        themeSegmentedControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        themeSegmentedControl.addTarget(self, action: #selector(themeSegmentedControlChanged), for: .valueChanged)
        themeSegmentedControl.selectedSegmentIndex = Theme.current.rawValue
        themeSegmentedControl.backgroundColor = UIColor.Pallete.Special.segmentedControl
        themeSegmentedControl.makeBorder()
        
        view.addSubview(shadowViewTheme)
        shadowViewTheme.snp.makeConstraints { make in
            make.top.equalTo(themeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        shadowViewTheme.layer.cornerRadius = themeSegmentedControl.layer.cornerRadius
        
        // Поястительная подпись
        view.addSubview(themeDescriptionLabel)
        themeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(themeSegmentedControl.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupOutButton() {
        view.addSubview(outButton)
        outButton.snp.makeConstraints { make in
            make.top.equalTo(themeDescriptionLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        outButton.backgroundColor = UIColor.Pallete.content
        outButton.setTitleColor(.systemRed, for: .normal)
        outButton.setTitle("Выйти", for: .normal)
        
        outButton.layer.cornerRadius = 10
        outButton.makeShadow()
        outButton.makeBorder()
        
        outButton.addTarget(self, action: #selector(didTapOutButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func themeSegmentedControlChanged() {
        Theme.init(rawValue: themeSegmentedControl.selectedSegmentIndex)?.setActive()
    }
    
    @objc
    private func updateText() {
        let tableName = "Settings"
        
        self.navigationItem.setLeftTitle(title: "nav.bar.title".localized(using: tableName))
        
        languages[0].displayName = "language.system".localized(using: tableName)
        
        languageLabel.text = "language".localized(using: tableName)
        languagesDescriptionLabel.text = "language.description".localized(using: tableName)
        
        themeLabel.text = "appearance".localized(using: tableName)
        themeSegmentedControl.setTitle("appearance.system".localized(using: tableName), forSegmentAt: 0)
        themeSegmentedControl.setTitle("appearance.light".localized(using: tableName), forSegmentAt: 1)
        themeSegmentedControl.setTitle("appearance.dark".localized(using: tableName), forSegmentAt: 2)
        themeDescriptionLabel.text = "appearance.description".localized(using: tableName)
        
        outButton.setTitle("sign.out".localized(using: tableName), for: .normal)
    }
    
    @objc
    private func didTapOutButton() {
        authService.outCurrUser()
        outButton.isHidden = true
    }

}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let elem = languages[indexPath.row]
        
        cell.selectionStyle = .none
        cell.tintColor = UIColor.Pallete.sibsuBlue
        cell.textLabel?.text = elem.displayName
        cell.backgroundColor = UIColor.Pallete.content
        
        if elem.isCurrent {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for (index, _) in languages.enumerated() {
            languages[index].isCurrent = false
        }
        
        // Нулевой - системный, он обрабатывается по другому
        if indexPath.row == 0 {
            Localize.resetCurrentLanguageToSystem()
            languages[0].isCurrent = true
        } else {
            let identifier = languages[indexPath.row].identifier
            Localize.setCurrentLanguage(identifier)
            languages[indexPath.row].isCurrent = true
        }
        
        tableView.reloadData()
    }
    
}

extension SettingsViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        shadowViewLanguage.makeShadow()
        shadowViewLanguage.makeBorder()
        
        themeSegmentedControl.makeBorder()
        
        outButton.makeShadow()
        outButton.makeBorder()
    }
    
}
