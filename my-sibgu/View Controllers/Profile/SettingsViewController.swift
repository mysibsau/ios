//
//  SettingsViewController.swift
//  my-sibgu
//
//  Created by art-off on 18.01.2021.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sibsuBlue
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let themeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Системное", "Светлое", "Темное"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        setupThemeSegmentedControl()
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setLeftTitle(title: "Настройки")
    }
    
    private func setupThemeSegmentedControl() {
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
        
        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.top.equalTo(themeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        shadowView.layer.cornerRadius = themeSegmentedControl.layer.cornerRadius
        shadowView.backgroundColor = .systemBackground
//        shadowView.makeShadow(color: .black, opacity: 0.15, shadowOffser: .zero, radius: 4)
    }

}
