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
    
    private let informingService = InformingService()
    
    private var data: EventsDataSource = []
    
    private let activityIndicatorView = UIActivityIndicatorView()
    
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
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .systemBackground
    }
    
    
    // MARK: - Life Circle -
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        
        configureCollectionView()
        
        loadEvents()
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
    
    private func loadEvents() {
        self.startActivityIndicator()
        informingService.getEvents { events in
            guard let e = events else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                return
            }

            DispatchQueue.main.async {
                self.set(events: e)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func set(events: [Event]) {
//        self.data = events.map { ($0, .short) }
        self.data = events.sorted(by: { $0.id > $1.id }).map { ($0, .short) }
        self.collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source -
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(data.count)
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortEventCollectionViewCell.reuseIdentifier, for: indexPath) as! ShortEventCollectionViewCell
        
        let event = data[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.set(mode: event.mode, image: event.event.logo, text: event.event.text)
        
        return cell
    }

}


extension EventsViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return collectionView
    }
    
}


extension EventsViewController: EventsCellDelegate {
    
    // MARK: TODO: При вызове `collectionViewLayout.invalidateLayout()` вызывается
    
    func setAndReload(cellMode: EventCellMode, at indexPath: IndexPath) {
        if cellMode == .long {
            informingService.viewPost(withId: data[indexPath.item].event.id) { _ in }
        }
        
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
