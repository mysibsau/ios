//
//  UnionsTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

class UnionsTableViewController: UITableViewController {
    
    private let campusService = CampusService()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    private var unions: [Union] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        configurateTableView()
        
        setUnions()
        
        updateText(isFirst: true)
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText(isFirst: Bool = false) {
        let tableName = "StudentsCollection"
        
        self.navigationItem.setLeftTitle(title: "unions".localized(using: tableName))
        
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
    
    private func setUnions() {
        let unionsFromLocal = campusService.getUnionsFromLocal()
        
        // Если в БД были объединения - то показываем их и без спинера качаем и обновляем
        if let unionsFromLocal = unionsFromLocal {
            set(unions: unionsFromLocal)
            loadUnions()
        // Если в БД ничего нет - то показываем спинет и качаем
        } else {
            self.startActivityIndicator()
            loadUnions()
        }
    }
    
    private func loadUnions() {
        campusService.getUnions { optionalUnions in
            guard let u = optionalUnions else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.set(unions: u)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(unions: [Union]) {
        let newUnions = unions.sorted(by: { $0.rank < $1.rank })
        if newUnions != self.unions {
            self.unions = newUnions
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnionTableViewCell.reuseIdentifier, for: indexPath) as! UnionTableViewCell
        
        let union = unions[indexPath.row]
        
        cell.nameLabel.text = union.name
        cell.logoImageView.loadImage(at: union.logoUrl)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(
            DetailViewController(viewModel: unions[indexPath.row]),
            animated: true)
    }

}

extension UnionsTableViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return view
    }
    
}

extension Union: DetailViewModel {
    
    var navigationTitle: String? { name }
    
    var backgroundImage: DetailModel.Image { .init(type: .url(logoUrl), useBlur: true) }
    var foregroundImage: DetailModel.Image { .init(type: .url(leaderPhotoUrl)) }
    
    func contentList(onPresenting viewController: UIViewController) -> [DetailModel.Content] {
        let tn = "Person"
        
        var aboutContent: [DetailModel.Content] = []
        if let about = about {
            aboutContent.append(.title("about".localized(using: tn)))
            aboutContent.append(.textView(.init(text: about)))
        }
        
        let leaderRankContetn: [DetailModel.Content]
        if let leaderRank = leaderRank, !leaderRank.isEmpty {
            leaderRankContetn = [.title(leaderRank)]
        } else {
            leaderRankContetn = [.title("head".localized(using: tn))]
        }
        
        var joinContent: [DetailModel.Content] = []
        if leaderPageVkUrl != nil {
            joinContent.append(.button(.init(imageName: "add_circle", text: "join.to".localized(using: tn), action: {
                let vc = JoinToUnionViewController()
                vc.unionId = id
                viewController.present(vc, animated: true)
            })))
        }
        
        return aboutContent + leaderRankContetn + [
            .nameView(leaderName),
            .imageAndTextView(.init(imageName: "place", text: address)),
            .button(.init(imageName: "phone", text: phone, action: {
                guard let url = phone.phoneUrl else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })),
            .button(.init(imageName: "vk", text: "group.vk".localized(using: tn), action: {
                if UIApplication.shared.canOpenURL(groupVkUrl) {
                    UIApplication.shared.open(groupVkUrl)
                }
            }))
        ] + joinContent
    }
}
