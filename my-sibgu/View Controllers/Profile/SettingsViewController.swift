//
//  SettingsViewController.swift
//  my-sibgu
//
//  Created by art-off on 18.01.2021.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    // MARK: - Theme UI
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Pallete.sibsuBlue
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let themeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Системное*", "Светлое", "Темное"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let themeDesctiption: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - Life Circle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Pallete.background
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        setupThemeSegmentedControl()
    }
    
    // MARK: - Sutup Views
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setLeftTitle(title: "Настройки")
    }
    
    private func setupThemeSegmentedControl() {
        // Заголовок над сменой темы
        view.addSubview(themeLabel)
        themeLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        themeLabel.text = "Оформление"
        
        
        // Добавил это теневое вью чтобы добавить тень к segmented control
        // но не могу изменить backgroundcolor у него на белый и поэтому тень плохая
        let shadowView = UIView()
        shadowView.addSubview(themeSegmentedControl)
        themeSegmentedControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        themeSegmentedControl.addTarget(self, action: #selector(themeSegmentedControlChanged), for: .valueChanged)
        themeSegmentedControl.selectedSegmentIndex = Theme.current.rawValue
        
        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.top.equalTo(themeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        shadowView.layer.cornerRadius = themeSegmentedControl.layer.cornerRadius
        shadowView.backgroundColor = .systemBackground
//        shadowView.makeShadow(color: .black, opacity: 0.15, shadowOffser: .zero, radius: 4)
        
        // Поястительная подпись
        view.addSubview(themeDesctiption)
        themeDesctiption.snp.makeConstraints { make in
            make.top.equalTo(themeSegmentedControl.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        themeDesctiption.text = "* Системное оформление - оформление приложение автоматически меняется при изменении оформления в настройках телефона"
    }
    
    // MARK: - Actions
    @objc
    private func themeSegmentedControlChanged() {
        Theme.init(rawValue: themeSegmentedControl.selectedSegmentIndex)?.setActive()
    }

}
