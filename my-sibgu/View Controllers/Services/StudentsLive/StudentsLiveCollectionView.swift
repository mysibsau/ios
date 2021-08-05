//
//  StudentsLiveCollectionView.swift
//  my-sibgu
//
//  Created by Artem Rylov on 06.08.2021.
//

import UIKit

private typealias ServicesDataSource = [(viewWithImage: UIView,
                                         name: String,
                                         vc: () -> UIViewController)]

class StudentsLiveCollectionView: UICollectionViewController {
    
    private var services: ServicesDataSource!
    
    
    private let spacing: CGFloat = 20
    private lazy var itemWidth = CollectionViewHelper.getItemWidth(
        byCollectionViewWidth: collectionView.bounds.width,
        numberItemsPerLine: 2,
        spacing: spacing)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        collectionView.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        collectionView.register(
            ServiceCollectionViewCell.self,
            forCellWithReuseIdentifier: ServiceCollectionViewCell.reuseIdentifier
        )
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 10)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        collectionView.collectionViewLayout = layout
        
        services = [
            (
                CollectionViewHelper.getViewWithImage(
                    image: UIImage(systemName: "map")!,
                    backgroundColor: UIColor.Pallete.sibsuBlue,
                    imageColor: UIColor.Pallete.content
                ),
                "1",
                { UnionsTableViewController() }
            ),
            (
                CollectionViewHelper.getViewWithImage(
                    image: UIImage(named: "institute")!,
                    backgroundColor: UIColor.Pallete.gray,
                    imageColor: UIColor.Pallete.content
                ),
                "2",
                { SportClubsTableViewController() }
            ),
            (
                // Раньше переходил на экран со всеми вопросами,
                // Но Илье не понравилось и теперь только один экран с одним опросом
                CollectionViewHelper.getFeedbackView(
                    backgroundColor: UIColor.Pallete.sibsuGreen,
                    imageColor: UIColor.Pallete.content
                ),
                "3",
                { DesignOfficesTableViewController() }
            ),
        ]
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    @objc
    private func updateText() {
        let tableName = "StudentsCollection"
        
        navigationItem.setLeftTitle(title: "nav.bar.title".localized(using: tableName))
        
        services[0].name = "unions".localized(using: tableName)
        services[1].name = "sport".localized(using: tableName)
        services[2].name = "sdo".localized(using: tableName)
        
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionView Data Source
extension StudentsLiveCollectionView {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ServiceCollectionViewCell.reuseIdentifier,
            for: indexPath) as! ServiceCollectionViewCell
        
        let service = services[indexPath.item]
//        cell.imageView.image = service.image.withRenderingMode(.alwaysTemplate)
//        cell.imageView.tintColor = service.color
        cell.configure(viewWithImage: service.viewWithImage)
        cell.nameLabel.text = service.name
        
        return cell
    }
    
}

// MARK: - UICollectionView Delegate
extension StudentsLiveCollectionView {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vcType = services[indexPath.item].vc
        
        navigationController?.pushViewController(vcType(), animated: true)
    }
    
}
