//
//  CustomViewController.swift
//  my-sibgu
//
//  Created by art-off on 20.01.2021.
//

import UIKit

class CustomViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = UIColor.Pallete.Special.tabNavBar
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc
    private func updateText() {
        let tableName = "TabBar"
        
        tabBar.items?[0].title = "feed".localized(using: tableName)
        tabBar.items?[1].title = "cafeteria".localized(using: tableName)
        tabBar.items?[2].title = "timetable".localized(using: tableName)
        tabBar.items?[3].title = "services".localized(using: tableName)
        tabBar.items?[4].title = "profile".localized(using: tableName)
    }
}
