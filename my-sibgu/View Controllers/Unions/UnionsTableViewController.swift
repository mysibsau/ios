//
//  UnionsTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

class UnionsTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        configurateTableView()
    }
    
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Объединения")
    }
    
    private func configurateTableView() {
        tableView.register(
            UnionTableViewCell.self,
            forCellReuseIdentifier: UnionTableViewCell.reuseIdentifier
        )
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnionTableViewCell.reuseIdentifier, for: indexPath) as! UnionTableViewCell
        
        
        
        cell.nameLabel.text = "sdlkfjsdl fsldkjf lsdjkf"
        
        return cell
    }

}
