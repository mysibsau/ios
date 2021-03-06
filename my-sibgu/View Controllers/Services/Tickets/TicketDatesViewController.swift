//
//  TicketDatesViewController.swift
//  my-sibgu
//
//  Created by art-off on 04.03.2021.
//

import UIKit

class TicketDatesViewController: UITableViewController {
    
//    private var vacancies: [Vacancy] = []
    
    
    private let activityIndicatorView =  UIActivityIndicatorView()

    // MARK: - Life Circle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Pallete.background
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        tableView.register(
            OneLabelTableViewCell.self,
            forCellReuseIdentifier: OneLabelTableViewCell.reuseIdentifier
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    @objc
    private func updateText() {
        let tableName = "Tickets"
        
        self.navigationItem.setLeftTitle(title: "date".localized(using: tableName))
    }
    
}

// MARK: - UITableView Data Source
extension TicketDatesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: OneLabelTableViewCell.reuseIdentifier,
            for: indexPath) as! OneLabelTableViewCell
        
//        let vacancy = vacancies[indexPath.row]
        
        cell.nameLabel.textAlignment = .center
        cell.nameLabel.text = "\(indexPath.row)1.20.2020\n0\(indexPath.row):00"
        
        return cell
    }
    
}

// MARK: - UITableView Delegate
extension TicketDatesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChoicePlaceViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
