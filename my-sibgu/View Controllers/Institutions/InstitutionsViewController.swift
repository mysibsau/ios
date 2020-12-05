//
//  InstitutionsViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit
import SnapKit

class InstitutionsViewController: UIViewController {
    
    private var indtitutions = [Institute]()
    
    
    private let rocketImageView = UIImageView()
    private let tableView = UITableView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            InstituteTableViewCell.self,
            forCellReuseIdentifier: InstituteTableViewCell.reuseIdentifier
        )

        setupNavBar()
        
        setupRocketImage()
        
        setupTableView()
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Институты")
    }
    
    private func setupRocketImage() {
        let rocketImage = UIImage(named: "rocket")
        rocketImageView.image = rocketImage
        rocketImageView.contentMode = .scaleAspectFit
        
        view.addSubview(rocketImageView)
        rocketImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.25)
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(rocketImageView.snp.trailing)
        }
    }

}


extension InstitutionsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstituteTableViewCell.reuseIdentifier, for: indexPath)
        
        return cell
    }

}

extension InstitutionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instituteVC = PersonViewController() // ТУТ ПРИСВАИВАТЬ ИНСТИТУТ
        navigationController?.pushViewController(instituteVC, animated: true)
    }

}
