//
//  DesignOfficesTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import UIKit

class DesignOfficesTableViewController: UITableViewController {
    
    private let campusService = CampusService()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private var designOffices: [DesignOffice] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        configurateTableView()
        
        setDesignOffices()
        
        updateText(isFirst: true)
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText(isFirst: Bool = false) {
        let tableName = "StudentsCollection"
        
        self.navigationItem.setLeftTitle(title: "sdo".localized(using: tableName))
        
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
            DesignOfficeTableCell.self,
            forCellReuseIdentifier: DesignOfficeTableCell.reuseIdentifier
        )
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    private func setDesignOffices() {
        let designOfficesFromLocal = campusService.getDesignOfficesFromLocal()
        
        if let designOfficesFromLocal = designOfficesFromLocal {
            set(designOffices: designOfficesFromLocal)
            loadDesignOffices()
        } else {
            self.startActivityIndicator()
            loadDesignOffices()
        }
    }
    
    private func loadDesignOffices() {
        campusService.getDesignOffice { optionalDesignOffices in
            guard let desO = optionalDesignOffices else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.set(designOffices: desO)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(designOffices: [DesignOffice]) {
        let newDesignOffices = designOffices
        if newDesignOffices != self.designOffices {
            self.designOffices = newDesignOffices
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return designOffices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DesignOfficeTableCell.reuseIdentifier, for: indexPath) as! DesignOfficeTableCell
        
        let designOffice = designOffices[indexPath.row]
        
        cell.nameLabel.text = designOffice.name
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(
            DetailViewController(viewModel: designOffices[indexPath.row]),
            animated: true)
    }
}

extension DesignOfficesTableViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return view
    }
    
}

extension DesignOffice: DetailViewModel {
    
    var navigationTitle: String? { name }
    
    var backgroundImage: DetailModel.Image { .init(type: .local("back_main_logo")) }
    var foregroundImage: DetailModel.Image { .init(type: .hide) }
    
    func contentList(onPresenting viewController: UIViewController) -> [DetailModel.Content] {
        let tn = "Person"
        
        var fioContent: [DetailModel.Content] = []
        if let fio = fio {
            fioContent.append(.title("head".localized(using: tn)))
            fioContent.append(.textView(.init(text: fio)))
        }
        var emailContent: [DetailModel.Content] = []
        if let email = email {
            emailContent.append(.imageAndTextView(.init(imageName: "email", text: email)))
        }
        
        return [
            .title("about".localized(using: tn)),
            .textView(.init(text: about)),
        ]
        + fioContent + [
            .imageAndTextView(.init(imageName: "place", text: address)),
        ] + emailContent
    }
}
