//
//  UnionsTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

class UnionsTableViewController: UITableViewController {
    
    private let campusService = CampusService()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private var unions: [Union] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        configurateTableView()
        
//        loadUnions()
        setUnions()
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
    
    private func setUnions() {
        let unionsFromLocal = campusService.getUnionsFromLocal()
        
        // Если в БД были объединения - то показываем их и без спинера качаем и обновляем
        if let unionsFromLocal = unionsFromLocal {
            set(unions: unionsFromLocal)
            loadUnions()
        // Если в БД ничего нет - то показываем спинет и качаем
        } else {
            self.startActivityIndicator()
            loadUnions()
        }
    }
    
    private func loadUnions() {
//        self.startActivityIndicator()
        print("fine1")
        campusService.getUnions { optionalUnions in
            print("fine2")
            guard let u = optionalUnions else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.set(unions: u)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(unions: [Union]) {
        print("hello")
        let newUnions = unions.sorted(by: { $0.name < $1.name })
        if newUnions != self.unions {
            print("hello1")
            self.unions = newUnions
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnionTableViewCell.reuseIdentifier, for: indexPath) as! UnionTableViewCell
        
        let union = unions[indexPath.row]
        
        
        cell.nameLabel.text = union.name
        cell.logoImageView.loadImage(at: union.logoUrl)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personVC = PersonViewController(union: unions[indexPath.row])
        
        navigationController?.pushViewController(personVC, animated: true)
    }

}

extension UnionsTableViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return view
    }
    
}
