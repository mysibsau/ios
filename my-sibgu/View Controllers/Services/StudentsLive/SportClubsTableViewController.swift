//
//  SportClubsTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import UIKit

class SportClubsTableViewController: UITableViewController {
    
    private let campusService = CampusService()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private var sportClubs: [SportClub] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        configurateTableView()
        
        setSportClubs()
        
        updateText(isFirst: true)
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText(isFirst: Bool = false) {
        let tableName = "StudentsCollection"
        
        self.navigationItem.setLeftTitle(title: "sport".localized(using: tableName))
        
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
    
    private func setSportClubs() {
        let sportClubsFromLocal = campusService.getSportClubsFromLocal()
        
        if let sportClubsFromLocal = sportClubsFromLocal {
            set(sportClubs: sportClubsFromLocal)
            loadSportClubs()
        } else {
            self.startActivityIndicator()
            loadSportClubs()
        }
    }
    
    private func loadSportClubs() {
        campusService.getSportClubs { optionalSportClubs in
            guard let sc = optionalSportClubs else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }

            DispatchQueue.main.async {
                self.set(sportClubs: sc)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(sportClubs: [SportClub]) {
        let newSportClubs = sportClubs
        if newSportClubs != self.sportClubs {
            self.sportClubs = newSportClubs
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportClubs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnionTableViewCell.reuseIdentifier, for: indexPath) as! UnionTableViewCell
        
        let sportClub = sportClubs[indexPath.row]
        
        cell.nameLabel.text = sportClub.name
        cell.logoImageView.loadImage(at: sportClub.logoUrl)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(
            DetailViewController(viewModel: sportClubs[indexPath.row]),
            animated: true)
    }

}

extension SportClubsTableViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return view
    }
    
}

extension SportClub: DetailViewModel {
    
    var navigationTitle: String? { name }
    
    var backgroundImage: DetailModel.Image { .init(type: .url(logoUrl)) }
    var foregroundImage: DetailModel.Image { .init(type: .hide) }
    
    func contentList(onPresenting viewController: UIViewController) -> [DetailModel.Content] {
        let tn = "Person"
        
        return [
            .title("head".localized(using: tn)),
            .textView(.init(text: fio)),
            .title("training.dates".localized(using: tn)),
            .textView(.init(text: dates)),
            .imageAndTextView(.init(imageName: "place", text: address)),
            .button(.init(imageName: "phone", text: phone, action: {
                guard let url = phone.phoneUrl else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }))
        ]
    }
}
