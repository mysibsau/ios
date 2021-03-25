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
            CancertTableViewCell.self,
            forCellReuseIdentifier: CancertTableViewCell.reuseIdentifier
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
        dump(concerts)
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
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableView Data Source
extension TicketDatesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concerts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CancertTableViewCell.reuseIdentifier,
            for: indexPath) as! CancertTableViewCell
        
        let concert = concerts[indexPath.row]
        
        cell.dateLabel.text = formattedDate(fromFullDateString: concert.date)
        cell.priceLabel.text = "\("from".localized(using: "Tickets")) \(Int(concert.minPrice)) ₽"
        cell.hallLabel.text = "\("hall".localized(using: "Tickets")): \(concert.hall)"
        cell.weekdayAndTimeLabel.text = "\(formattedWeekDay(fromFullDateString: concert.date)), \(concert.time)"
        
        return cell
    }
    
    private func formattedDate(fromFullDateString fullDate: String) -> String {
        guard let date = date(fromFullDateString: fullDate) else { return fullDate }
        
        let df = DateFormatter()
        df.locale = Locale(identifier: Localize.currentLanguage)
        df.dateFormat = "d MMMM"
        
        return df.string(from: date)
    }
    
    private func formattedWeekDay(fromFullDateString fullDate: String) -> String {
        guard let date = date(fromFullDateString: fullDate) else { return fullDate }
        
        let df = DateFormatter()
        df.locale = Locale(identifier: Localize.currentLanguage)
        df.dateFormat = "EEEE"
        
        return df.string(from: date)
    }
    
    private func date(fromFullDateString fullDate: String) -> Date? {
        let df = DateFormatter()
        df.locale = Locale(identifier: Localize.currentLanguage)
        df.dateFormat = "dd.MM.yyyy"
        
        return df.date(from: fullDate)
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
