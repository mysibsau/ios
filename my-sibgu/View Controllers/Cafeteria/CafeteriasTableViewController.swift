//
//  CafeteriasTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 20.02.2021.
//

import UIKit


protocol CafeterialViewControllerProtocol {
    func set(cafeterias: [Cafeteria])
}


class CafeteriasTableViewController: UITableViewController {
    
    var cafeterias: [Cafeteria] = []
    
    private let cafeteriaService = CafetefiaService()
    
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let alertView = AlertView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        view.backgroundColor = UIColor.Pallete.background
        
        tableView.contentInset.top = 5
        
        tableView.separatorStyle = .none
        tableView.register(
            OneLabelTableViewCell.self,
            forCellReuseIdentifier: OneLabelTableViewCell.reuseIdentifier
        )
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
        
        // Если есть сохраненная столовка - открываем экран и качаем оттуда
        // Иначе - качаем тут
        if let lastCafeteria = UserDefaultsConfig.cafeteria {
            let vc = MenuTableViewController()
            vc.delegate = self
            vc.lastCafeteriaName = lastCafeteria
            navigationController?.pushViewController(vc, animated: false)
        } else {
            loadCafeterial()
        }
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    @objc
    private func updateText() {
        let tableName = "Cafeteria"
        
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "nav.bar.title.cafeteria".localized(using: tableName))
    }
    
    private func loadCafeterial() {
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
                self.set(cafeterias: c)
                self.stopActivityIndicator()
            }
        }
    }
    
    func set(cafeterias: [Cafeteria]) {
        self.cafeterias = cafeterias
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeterias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: OneLabelTableViewCell.reuseIdentifier,
            for: indexPath) as! OneLabelTableViewCell
        
        cell.nameLabel.text = cafeterias[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cafeteria = cafeterias[indexPath.row]
        
        UserDefaultsConfig.cafeteria = cafeteria.name
        
        let vc = MenuTableViewController()
        vc.cafeteria = cafeteria
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension CafeteriasTableViewController: AlertingViewController {
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
}

extension CafeteriasTableViewController: AnimatingNetworkProtocol {
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
}

extension CafeteriasTableViewController: CafeterialViewControllerProtocol { }
