//
//  MenuTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 20.02.2021.
//

import UIKit

class MenuTableViewController: UITableViewController {

    var cafeteria: Cafeteria!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        view.backgroundColor = UIColor.Pallete.background
        
        tableView.separatorStyle = .none
        tableView.register(
            DinerTableViewCell.self,
            forCellReuseIdentifier: DinerTableViewCell.reuseIdentifier
        )
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    @objc
    private func updateText() {
        let tableName = "Cafeteria"
        
        self.navigationItem.setLeftTitle(title: "nav.bar.title.menu".localized(using: tableName))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cafeteria.menus.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeteria.menus[section].diners.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cafeteria.menus[section].type
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.Pallete.background
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.Pallete.sibsuBlue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DinerTableViewCell.reuseIdentifier, for: indexPath) as! DinerTableViewCell
        
        let diner = cafeteria.menus[indexPath.section].diners[indexPath.row]
        cell.weightLabel.text = diner.weight + " г."
        cell.nameLabel.text = diner.name
        cell.priceLabel.text = String(diner.price) + "₽"
        
        return cell
    }

}
