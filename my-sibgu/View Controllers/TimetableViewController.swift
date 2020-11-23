//
//  TimetableViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

class TimetableViewController: UIViewController {

    var button1: UIButton?
    
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        addShadowToBar()
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        button1 = UIButton()
        button1?.setTitle("1 неделя", for: .normal)
        button1?.setTitleColor(.gray, for: .normal)
        button1?.addTarget(self, action: #selector(aaa), for: .touchUpInside)
        button1?.translatesAutoresizingMaskIntoConstraints = false
        
        let v = UIView()
        v.addSubview(button1!)
        
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 5
        
        v.layer.cornerRadius = 15
        
        button1?.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
        button1?.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
        button1?.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
        button1?.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
        
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: 100).isActive = true
        v.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let a = UIBarButtonItem(customView: v)
        self.navigationItem.rightBarButtonItem = a
        
        
        let b = UIButton()
        b.addTarget(self, action: #selector(bbb), for: .touchUpInside)
        view.addSubview(b)
        
        b.translatesAutoresizingMaskIntoConstraints = false
        b.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        b.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func bbb() {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func aaa() {
        button1?.setTitle("\(i) неделя", for: .normal)
        i += 1
    }
    
    func addShadowToBar() {
        let shadowView = UIView(frame: navigationController!.navigationBar.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        shadowView.layer.shadowRadius = 2
        view.addSubview(shadowView)
    }

}
