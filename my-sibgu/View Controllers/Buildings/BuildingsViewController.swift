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
        
        setBuildings()
//        loadBuildings()
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Корпуса")
    }
    
    private func setBuildings() {
        let buildingsFromLocal = campusService.getBuildingsFromLocal()
        
        // Если в БД были объединения - то показываем их и без спинера качаем и обновляем
        if let buildingsFromLocal = buildingsFromLocal {
            set(buildings: buildingsFromLocal)
            loadBuildings()
        // Если в БД ничего нет - то показываем спинет и качаем
        } else {
            self.startActivityIndicator()
            loadBuildings()
        }
    }
    
    private func loadBuildings() {
        campusService.getBuildings { optionalBuildings in
            guard let b = optionalBuildings else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }

            DispatchQueue.main.async {
                self.set(buildings: b)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(buildings: [Building]) {
        let newRightBuildings = buildings.filter({ $0.coast == .right }).sorted(by: { $0.name < $1.name })
        let newLeftBuildings = buildings.filter({ $0.coast == .left }).sorted(by: { $0.name < $1.name })
        
        // В массиве 2 элемента: 0 - правый берег, 1 - левый
        // Если размер массива не равен 2 - там ничего нет и можно заполнять
        if self.buildings.count == 2 {
            if newRightBuildings != self.buildings[0], newLeftBuildings != self.buildings[1] {
                self.buildings = [
                    newRightBuildings,
                    newLeftBuildings
                ]
            }
        } else {
            self.buildings = [
                newRightBuildings,
                newLeftBuildings
            ]
        }
        self.tableView.reloadData()
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

// MARK: - Table View Delegate
extension BuildingsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let building = buildings[indexPath.section][indexPath.row]
        if UIApplication.shared.canOpenURL(building.urlTo2gis) {
            UIApplication.shared.open(building.urlTo2gis)
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
