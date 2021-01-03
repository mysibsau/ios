//
//  BuildingsViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

class BuildingsViewController: UITableViewController {
    
//    private var universityInfoService = UniversityInfoService()
    private var buildings = [[Building]]()

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

}

// MARK: - UI Table View Data Source
extension BuildingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BuildingTableViewCell.reuseIdentifier, for: indexPath) as! BuildingTableViewCell
        cell.buildingNameLabel.text = "A\(indexPath.row)"
        cell.buildingTypeLabel.text = "Корпус"
        cell.buildingAddressLabel.text = "Адресс большой вроде Красраб хуе мое е е е е \(indexPath.row)"
        if indexPath.section == 0 {
            cell.separateLine.backgroundColor = Colors.sibsuBlue
        } else if indexPath.section == 1 {
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
