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
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
        
//        UINavigationBar.appearance().barTintColor = UIColor.Pallete.content
        //        UINavigationBar.appearance().tintColor = UIColor.white
        //        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        //
//        self.appe.backgroundColor = UIColor.red;
                
//        UITabBar.appearance().backgroundColor = .init(hex: "FFFFFF")
        
//        self.tabBar.tintColor = .red
//        self.tabBar.backgroundColor = .red
        
        
        
        self.tabBar.barTintColor = UIColor.Pallete.Special.tabNavBar
        
        print(self.tabBar.barTintColor)
        
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
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        if tabBar.barTintColor == .green {
//            tabBar.barTintColor = .red
//        } else {
//            tabBar.barTintColor = .green
//        }
//    }

}
