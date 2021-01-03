//
//  BuildingsViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

class BuildingsViewController: UITableViewController {
    
    private let campusService = CampusService()
    private var buildings = [[Building]]()
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)

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
        
        loadBuildings()
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Корпуса")
    }
    
    private func loadBuildings() {
        self.startActivityIndicator()
        campusService.getBuildings { optionalBuildings in
            guard let b = optionalBuildings else {
                self.stopActivityIndicator()
                return
            }
            
            self.buildings = [
                b.filter({ $0.coast == .right }).sorted(by: { $0.name < $1.name }),
                b.filter({ $0.coast == .left }).sorted(by: { $0.name < $1.name })
            ]
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopActivityIndicator()
            }
        }
    }

}

// MARK: - UI Table View Data Source
extension BuildingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return buildings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BuildingTableViewCell.reuseIdentifier, for: indexPath) as! BuildingTableViewCell
        let building = buildings[indexPath.section][indexPath.row]
        cell.buildingNameLabel.text = building.name
        cell.buildingTypeLabel.text = building.type
        cell.buildingAddressLabel.text = building.address
        if building.coast == .right {
            cell.separateLine.backgroundColor = Colors.sibsuBlue
        } else if building.coast == .left {
            cell.separateLine.backgroundColor = Colors.sibsuGreen
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Правый берег"
        } else if section == 1 {
            return "Левый берег"
        } else {
            return nil
        }
    }
    
}

extension BuildingsViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return view
    }
    
}
