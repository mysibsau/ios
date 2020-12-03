//
//  BuildingsViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

class BuildingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .systemBackground

        setupNavBar()
        
        tableView.register(
            BuildingTableViewCell.self,
            forCellReuseIdentifier: BuildingTableViewCell.reuseIdentifier
        )
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Корпуса")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "hello world"
    }

}

extension BuildingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BuildingTableViewCell.reuseIdentifier, for: indexPath) as! BuildingTableViewCell
        
        return cell
    }
    
}
