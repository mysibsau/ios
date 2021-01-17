//
//  SurveysTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 17.01.2021.
//

import UIKit

class SurveysTableViewController: UITableViewController {
    
    private let surveysService = SurveysService()
    
    private var surveys: [ShortSurvey] = []
    
    
    private let activityIndicatorView =  UIActivityIndicatorView()

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        tableView.register(
            ShortSurveyTableViewCell.self,
            forCellReuseIdentifier: ShortSurveyTableViewCell.reuseIdentifier
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        loadEvents()
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Опросы")
    }
    
    // MARK: - Helper Method
    private func loadEvents() {
        self.startActivityIndicator()
        surveysService.getAllSurveys { surveys in
            guard let s = surveys else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.set(surveys: s)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(surveys: [ShortSurvey]) {
        self.surveys = surveys.sorted(by: { $0.id > $1.id })
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableView Data Source
extension SurveysTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShortSurveyTableViewCell.reuseIdentifier,
            for: indexPath) as! ShortSurveyTableViewCell
        
        let survey = surveys[indexPath.row]
        
        cell.nameLabel.text = survey.name
        
        return cell
    }
    
}

// MARK: - UITableView Delegate
extension SurveysTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shortSurvey = surveys[indexPath.row]
        
        
    }
    
}

extension SurveysTableViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        tableView
    }
    
}
