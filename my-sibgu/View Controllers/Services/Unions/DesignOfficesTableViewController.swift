//
//  DesignOfficesTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import UIKit

//class DesignOfficesTableViewController: UITableViewController {
//    
//    private let campusService = CampusService()
//    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
//    
//    private var designOffices: [DesignOffice] = []
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = UIColor.Pallete.background
//        
//        setupNavBar()
//        
//        configurateTableView()
//        
//        setDesignOffices()
//        
//        updateText(isFirst: true)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
//    }
//    
//    @objc
//    private func updateText(isFirst: Bool = false) {
//        let tableName = "StudentLife"
//        
//        self.navigationItem.setLeftTitle(title: "nav.bar.title".localized(using: tableName))
//        
//        if !isFirst {
//            navigationController?.popToRootViewController(animated: true)
//        }
//    }
//    
//    private func setupNavBar() {
//        self.navigationController?.configurateNavigationBar()
//        self.navigationItem.configurate()
//    }
//    
//    private func configurateTableView() {
//        tableView.register(
//            UnionTableViewCell.self,
//            forCellReuseIdentifier: UnionTableViewCell.reuseIdentifier
//        )
//        
//        tableView.showsVerticalScrollIndicator = false
//        tableView.showsHorizontalScrollIndicator = false
//        tableView.separatorStyle = .none
//        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//    }
//    
//    private func setDesignOffices() {
////        let designOfficesFromLocal = campusService.getde
////        let sportClubsFromLocal = campusService.getSportClubsFromLocal()
////
////        if let sportClubsFromLocal = sportClubsFromLocal {
////            set(sportClubs: sportClubsFromLocal)
////            loadSportClubs()
////        } else {
////            self.startActivityIndicator()
////            loadSportClubs()
////        }
//    }
//    
//    private func loadDesignOffices() {
//        campusService.getSportClubs { optionalSportClubs in
//            guard let sc = optionalSportClubs else {
//                DispatchQueue.main.async {
//                    self.stopActivityIndicator()
//                }
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.set(sportClubs: sc)
//                self.stopActivityIndicator()
//            }
//        }
//    }
//    
//    private func set(designOffices: [DesignOffice]) {
//        let newDesignOffices = designOffices
//        if newDesignOffices != self.designOffices {
//            self.designOffices = newDesignOffices
//            self.tableView.reloadData()
//        }
//    }
//    
//    // MARK: - Table View Data Source
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sportClubs.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: UnionTableViewCell.reuseIdentifier, for: indexPath) as! UnionTableViewCell
//        
//        let sportClub = sportClubs[indexPath.row]
//        
//        cell.nameLabel.text = sportClub.name
//        cell.logoImageView.loadImage(at: sportClub.logoUrl)
//        
//        return cell
//    }
//    
//    // MARK: - Table View Delegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let personVC = PersonViewController(sportClub: sportClubs[indexPath.row])
//        
//        navigationController?.pushViewController(personVC, animated: true)
//    }
//
//}
//
//extension DesignOfficesTableViewController: AnimatingNetworkProtocol {
//    
//    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
//        return activityIndicatorView
//    }
//    
//    func animatingSuperViewForDisplay() -> UIView {
//        return view
//    }
//    
//}
