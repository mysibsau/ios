//
//  TimetableSearchViewController.swift
//  my-sibgu
//
//  Created by art-off on 25.11.2020.
//

import UIKit

class TimetableSearchViewController: UIViewController {

    var rightBarButton: UIButton?
    var leftBarItem: UIBarButtonItem?
    
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Расписание")
        
        // для тестов
        let b = UIButton()
        b.setTitle("bbbb", for: .normal)
        b.addTarget(self, action: #selector(bbb), for: .touchUpInside)
        b.backgroundColor = .red
        view.addSubview(b)
        
        b.translatesAutoresizingMaskIntoConstraints = false
        b.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        b.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func bbb() {
        let vc = TimetableViewController()
        vc.view.backgroundColor = .white
        navigationController?.pushViewController(vc, animated: true)
    }

}
