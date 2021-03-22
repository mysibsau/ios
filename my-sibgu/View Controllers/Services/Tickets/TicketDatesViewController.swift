//
//  TicketDatesViewController.swift
//  my-sibgu
//
//  Created by art-off on 04.03.2021.
//

import UIKit

class TicketDatesViewController: UITableViewController {
    
    private let ticketsService = TicketsService()
    
    
    var performance: Performance!
    private var concerts: [PerformanceConcert] = []
    
    private let activityIndicatorView =  UIActivityIndicatorView()
    
    
    convenience init(performance: Performance) {
        self.init()
        self.performance = performance
    }
    
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
        
        loadConcerts()
    }
    
    
    private func loadConcerts() {
        startActivityIndicator()
        ticketsService.getConcert(by: performance.id) { concerts in
            guard let concerts = concerts else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.set(concerts: concerts)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(concerts: [PerformanceConcert]) {
        self.concerts = concerts
        tableView.reloadData()
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
        return concerts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: OneLabelTableViewCell.reuseIdentifier,
            for: indexPath) as! OneLabelTableViewCell
        
        let concert = concerts[indexPath.row]
        
        cell.nameLabel.textAlignment = .center
        cell.nameLabel.text = "\(concert.date) \(concert.time)"
        
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


extension TicketDatesViewController: AnimatingNetworkProtocol {
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
}
