//
//  MenuTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 20.02.2021.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    private let cafeteriaService = CafetefiaService()
    
    var delegate: CafeterialViewControllerProtocol?
    var lastCafeteriaName: String?

    var cafeteria: Cafeteria! = Cafeteria(name: "", menus: [])
    
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let alertView = AlertView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
        
        setupNavBar()
        
        view.backgroundColor = UIColor.Pallete.background
        
        tableView.separatorStyle = .none
        tableView.register(
            DinerTableViewCell.self,
            forCellReuseIdentifier: DinerTableViewCell.reuseIdentifier
        )
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
        
        if let lastCafeteriaName = lastCafeteriaName {
            loadCafeterialAndShow(with: lastCafeteriaName)
        } else {
            tableView.reloadData()
        }
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    @objc
    private func updateText() {
//        let tableName = "Cafeteria"
        
        if let lastCafeteriaName = lastCafeteriaName {
            self.navigationItem.setLeftExitButtonAndLeftTitle(title: lastCafeteriaName, vc: self)
        } else {
            self.navigationItem.setLeftExitButtonAndLeftTitle(title: cafeteria.name, vc: self)
        }
    }
    
    private func loadCafeterialAndShow(with name: String) {
        self.startActivityIndicator()
        cafeteriaService.getAllCafeterias { cafeterias in
            guard let c = cafeterias else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.showNetworkAlert()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.set(cafeterias: c)
                
                if let curr = c.filter({ $0.name == name }).first {
                    self.cafeteria = curr
                    self.tableView.reloadData()
                } else {
                    self.popViewController()
                }
                
                self.stopActivityIndicator()
            }
        }
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
        cell.priceLabel.text = String(diner.price) + " ₽"
        if let included = diner.included {
            cell.includedLabel.text = "(\(included))"
        } else {
            cell.includedLabel.text = nil
        }
        
        return cell
    }

}

extension MenuTableViewController: AlertingViewController {
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
}

extension MenuTableViewController: AnimatingNetworkProtocol {
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
}

extension MenuTableViewController: PopableViewController {
    func popViewController() {
        UserDefaultsConfig.cafeteria = nil
        navigationController?.popViewController(animated: true)
    }
}

extension MenuTableViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == navigationController! {
            tabBarController.selectedIndex = 1
            return false
        }
        return true
    }
}
