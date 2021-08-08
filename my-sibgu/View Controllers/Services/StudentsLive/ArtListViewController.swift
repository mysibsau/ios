//
//  ArtListViewController.swift
//  my-sibgu
//
//  Created by Artem Rylov on 07.08.2021.
//

import UIKit

class ArtListViewController: UITableViewController {
    
    private let campusService = CampusService()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private var arts: [ArtAssociation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        configurateTableView()
        
        setArts()
        
        updateText(isFirst: true)
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText(isFirst: Bool = false) {
        let tableName = "StudentsCollection"
        
        self.navigationItem.setLeftTitle(title: "art".localized(using: tableName))
        
        if !isFirst {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
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
    
    private func setArts() {
        let artFromLocal = campusService.getArtsFromLocal()
        
        if let artFromLocal = artFromLocal {
            set(arts: artFromLocal)
            loadArts()
        } else {
            self.startActivityIndicator()
            loadArts()
        }
    }
    
    private func loadArts() {
        campusService.getArts { arts in
            guard let arts = arts else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }

            DispatchQueue.main.async {
                self.set(arts: arts)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(arts: [ArtAssociation]) {
        if arts != self.arts {
            self.arts = arts
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnionTableViewCell.reuseIdentifier, for: indexPath) as! UnionTableViewCell
        
        let sportClub = arts[indexPath.row]
        
        cell.nameLabel.text = sportClub.name
        cell.logoImageView.loadImage(at: sportClub.logo)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personVC = PersonViewController(art: arts[indexPath.row])
        navigationController?.pushViewController(personVC, animated: true)
    }

}

extension ArtListViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return view
    }
    
}
