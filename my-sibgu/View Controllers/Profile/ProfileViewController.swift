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
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Профиль")
    }
    
    private func addSettiongsBarButton() {
        let gearImage = UIImage(systemName: "gearshape.fill")
        let barButton = UIBarButtonItem(image: gearImage, style: .done, target: self, action: #selector(showSettiongs))
        barButton.tintColor = .gray
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc
    private func showSettiongs() {
        // MARK: TODO:
    }

}
