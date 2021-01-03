//
//  EventsViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit
import SnapKit

private typealias EventsDataSource = [(event: Event, mode: EventCellMode)]

class EventsViewController: UICollectionViewController {
    
    private var data: EventsDataSource!
    
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
        
        data = Common.getEvents().map { ($0, EventCellMode.short) }
        collectionView.reloadData()
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
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortEventCollectionViewCell.reuseIdentifier, for: indexPath) as! ShortEventCollectionViewCell
        
        let event = data[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.set(mode: event.mode, image: UIImage(named: event.event.author), text: event.event.postTest)
//        cell.set(mode: event.mode, image: nil, text: event.event.postTest)
        
        return cell
    }

}


extension EventsViewController: EventsCellDelegate {
    
    func setAndReload(cellMode: EventCellMode, at indexPath: IndexPath) {
        data[indexPath.item].mode = cellMode
        let offset = collectionView.contentOffset
        let cell = self.collectionView.cellForItem(at: indexPath) as! ShortEventCollectionViewCell
        cell.set(mode: cellMode)
        
        // Если хочу добавить анимации, то нужно отдавание размера ячейки в collectionView так
        // как вот тут в проекте https://www.raywenderlich.com/9106-iglistkit-tutorial-better-uicollectionviews
        UIView.performWithoutAnimation {
            DispatchQueue.main.async {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.layoutIfNeeded()
                self.collectionView.setContentOffset(offset, animated: false)
            }
        }
    }
    
}
