//
//  TimetableViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

class TimetableViewController: UIViewController {
    
    var rightBarButton: UIButton?
    var leftBarItem: UIBarButtonItem?
    
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setLeftExitButtonAndLeftTitle(title: "Филимонова М. Н", vc: self)
        
        setupRightBarButton()
    }
    
    private func setupRightBarButton() {
        rightBarButton = UIButton()
        rightBarButton?.setTitle("1 неделя", for: .normal)
        rightBarButton?.setTitleColor(.gray, for: .normal)
        rightBarButton?.addTarget(self, action: #selector(aaa), for: .touchUpInside)
        
        let viewRightBarButton = UIView()
        viewRightBarButton.addSubview(rightBarButton!)
        viewRightBarButton.makeShadow(color: .black, opacity: 0.5, shadowOffser: .zero, radius: 3)
        viewRightBarButton.layer.cornerRadius = 15
        
        rightBarButton?.translatesAutoresizingMaskIntoConstraints = false
        rightBarButton?.centerYAnchor.constraint(equalTo: viewRightBarButton.centerYAnchor).isActive = true
        rightBarButton?.centerXAnchor.constraint(equalTo: viewRightBarButton.centerXAnchor).isActive = true
        
        viewRightBarButton.backgroundColor = .white
        viewRightBarButton.translatesAutoresizingMaskIntoConstraints = false
        viewRightBarButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        viewRightBarButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewRightBarButton)
    }
    
    @objc private func aaa() {
        rightBarButton?.setTitle("\(i) неделя", for: .normal)
        i += 1
    }
    
}

extension TimetableViewController: PopableViewController {
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}
