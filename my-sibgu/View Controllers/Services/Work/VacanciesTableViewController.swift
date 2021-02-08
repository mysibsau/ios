//
//  VacanciesTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 06.02.2021.
//

import UIKit

class VacanciesTableViewController: UITableViewController {
    
    private let workService = WorkService()
    
    private var vacancies: [Vacancy] = []
    
    
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
        
        loadVacancies()
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    @objc
    private func updateText() {
        let tableName = "Work"
        
        self.navigationItem.setLeftTitle(title: "nav.bar.title".localized(using: tableName))
    }
    
    // MARK: - Helper Method
    private func loadVacancies() {
        self.startActivityIndicator()
        workService.getAllVacancies { vacancies in
            guard let v = vacancies else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.set(vacancies: v)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(vacancies: [Vacancy]) {
        self.vacancies = vacancies//.sorted(by: { $0.id > $1.id })
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableView Data Source
extension VacanciesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacancies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: OneLabelTableViewCell.reuseIdentifier,
            for: indexPath) as! OneLabelTableViewCell
        
        let vacancy = vacancies[indexPath.row]
        
        cell.nameLabel.text = vacancy.name
        
        return cell
    }
    
}

// MARK: - UITableView Delegate
extension VacanciesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vacancy = vacancies[indexPath.row]
        
        let vc = VacancyViewController(vacancy: vacancy)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension VacanciesTableViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        tableView
    }
    
}
