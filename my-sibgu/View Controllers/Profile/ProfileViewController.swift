//
//  ProfileViewController.swift
//  my-sibgu
//
//  Created by art-off on 18.01.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        addSettiongsBarButton()
        
        self.updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    private func addSettiongsBarButton() {
        let gearImage = UIImage(systemName: "gearshape.fill")
        let barButton = UIBarButtonItem(image: gearImage, style: .done, target: self, action: #selector(showSettiongs))
        barButton.tintColor = .gray
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc
    private func showSettiongs() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func updateText() {
        let tableName = "Profile"
        
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "navBarTitle".localized(using: tableName))
    }

}
