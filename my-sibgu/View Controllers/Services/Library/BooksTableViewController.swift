//
//  BooksTableViewController.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import UIKit

enum BooksViewModel {
    case digital([DigitalBook])
    case physical([PhysicalBook])
}

class BooksTableViewController: UITableViewController {
    
    private let workService = WorkService()
    
    var viewModel: BooksViewModel!
    
    
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
            BookTableViewCell.self,
            forCellReuseIdentifier: BookTableViewCell.reuseIdentifier
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
//        let tableName = "Library"
    }
    
}

// MARK: - UITableView Data Source
extension BooksTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel {
        case .digital(let books):
            return books.count
        case .physical(let books):
            return books.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel {
        case .digital(let books):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BookTableViewCell.reuseIdentifier,
                for: indexPath) as! BookTableViewCell
            
            let book = books[indexPath.row]
            cell.nameLabel.text = book.name
            cell.authorLabel.text = book.author
            return cell
        case .physical(let books):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BookTableViewCell.reuseIdentifier,
                for: indexPath) as! BookTableViewCell
            
            let book = books[indexPath.row]
            cell.nameLabel.text = book.name
            cell.authorLabel.text = book.author
            cell.goToLabel.text = "Можете найти в \(book.place) (\(book.count) шт.)"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

// MARK: - UITableView Delegate
extension BooksTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel {
        case .digital(let books):
            let book = books[indexPath.row]
            if let url = book.url {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        default: break
        }
    }

}
