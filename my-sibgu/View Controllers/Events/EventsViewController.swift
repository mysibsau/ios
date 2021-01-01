//
//  EventsViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit
import SnapKit

class EventsViewController: UICollectionViewController {
    
    private var events: [Event]!
    
    // MARK: - Collection View Layout
    private let spacing: CGFloat = 6
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        // Предполагаемый размер ячейки
        layout.estimatedItemSize = CGSize(width: width - 2 * spacing, height: 10)
        // Отступ между элементами (линимями элементов)
        layout.minimumLineSpacing = 2 * spacing
        return layout
    }()
    
    lazy var contentInset: UIEdgeInsets = {
        return UIEdgeInsets(top: 2 * spacing, left: spacing, bottom: 2 * spacing, right: spacing)
    }()
    
    
    // MARK: - Life Circle -
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        
        configureCollectionView()
    }
    
    
    // MARK: - Private Helper -
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Мероприятия")
    }
    
    private func configureCollectionView() {
        collectionView.register(
            ShortEventCollectionViewCell.self,
            forCellWithReuseIdentifier: ShortEventCollectionViewCell.reuseIdentifier)
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.contentInset = contentInset
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Collection View Data Source -
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortEventCollectionViewCell.reuseIdentifier, for: indexPath) as! ShortEventCollectionViewCell
        
        if indexPath.row < 5 || indexPath.row > 10 {
            cell.set(image: UIImage(named: "test1"))
        //} else if indexPath.row >= 5 {
            //cell.set(image: UIImage(named: "test2"))
        } else {
            cell.set(image: UIImage(named: "test2"))
        }
        
        if indexPath.row % 5 == 0 {
            cell.set(image: UIImage(named: "test1"))
            cell.textLabel.text = "Я ебал"
        } else if indexPath.row % 5 == 1 {
            cell.set(image: UIImage(named: "test2"))
            cell.textLabel.text = "Меня ебали ебали ебали ебали ебали ебали ебали ебали Меня ебали ебали ебали ебали ебали ебали ебали ебали Меня ебали ебали ебали ебали ебали ебали ебали ебали Меня ебали ебали ебали ебали ебали ебали ебали ебали"
        } else if indexPath.row % 5 == 2 {
            cell.set(image: UIImage(named: "test3"))
            cell.textLabel.text = "Я сосал"
        } else if indexPath.row % 5 == 3 {
            cell.set(image: UIImage(named: "test4"))
            cell.textLabel.text = "Меня сосали сосали сосали сосали сосали сосали сосали сосали"
        } else {
            cell.set(image: UIImage(named: "test7"))
            cell.textLabel.text = "Я не ебал"
        }
        
//        cell.label.text = "\(indexPath.row)"
        cell.layoutIfNeeded()
        
        return cell
    }

}
