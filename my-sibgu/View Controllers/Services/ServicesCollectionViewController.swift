//
//  ServicesCollectionViewController.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import UIKit

private typealias ServicesDataSource = [(viewWithImage: UIView, name: String, vc: () -> UIViewController)]

class ServicesCollectionViewController: UICollectionViewController {
    
    private var services: ServicesDataSource!
    
    
    private let spacing: CGFloat = 10
    private lazy var itemWidth = CollectionViewHelper.getItemWidth(
        byCollectionViewWidth: collectionView.bounds.width,
        numberItemsPerLine: 3,
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
                "Строения",
                { BuildingsViewController() }
            ),
            (
                CollectionViewHelper.getViewWithImage(
                    image: UIImage(named: "institute")!,
                    backgroundColor: UIColor.Pallete.gray,
                    imageColor: UIColor.Pallete.content
                ),
                "Институты",
                { InstitutionsViewController() }
            ),
            (
                CollectionViewHelper.getViewWithImage(
                    image: UIImage(systemName: "person.2.fill")!,
                    backgroundColor: UIColor.Pallete.green,
                    imageColor: UIColor.Pallete.content
                ),
                "Студ. жизнь",
                { StudentsLiveCollectionView(collectionViewLayout: .init()) }
            ),
//            (
//                CollectionViewHelper.getViewWithImage(
//                    image: UIImage(named: "work")!,
//                    backgroundColor: UIColor.Pallete.sibsuGreen,
//                    imageColor: UIColor.Pallete.content
//                ),
//                "Работа",
//                { VacanciesTableViewController() }
//            ),
            (
                CollectionViewHelper.getViewWithImage(
                    image: UIImage(systemName: "book.fill")!,
                    backgroundColor: UIColor.Pallete.sibsuBlue,
                    imageColor: UIColor.Pallete.content
                ),
                "Библиотека",
                { LibrarySearchViewController() }
            ),
//            (
//                CollectionViewHelper.getViewWithImage(
//                    image: UIImage(named: "theater")!,
//                    backgroundColor: UIColor.Pallete.sibsuGreen,
//                    imageColor: UIColor.Pallete.content
//                ),
//                "Билеты",
//                vc: CatalogCollectionViewController.self
//            )
        ]
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Сервисы")
    }
    
    @objc
    private func updateText() {
        let tableName = "Services"
        
        navigationItem.setBarLeftMainLogoAndLeftTitle(title: "nav.bar.title".localized(using: tableName))
        
        services[0].name = "buildings".localized(using: tableName)
        services[1].name = "institutes".localized(using: tableName)
        services[2].name = "student.life".localized(using: tableName)
//        services[3].name = "work".localized(using: tableName)
        services[3].name = "library".localized(using: tableName)
//        services[7].name = "tickets".localized(using: tableName)
        
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionView Data Source
extension ServicesCollectionViewController {
    
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
        print(UIScreen.main.bounds.size.width)
        
        // For SE
        if UIScreen.main.bounds.size.width < 375 {
            cell.nameLabel.font = .systemFont(ofSize: 13, weight: .medium)
            if indexPath.row == 2 {
                cell.nameLabel.font = .systemFont(ofSize: 11, weight: .medium)
            }
        } else if indexPath.row == 2 {
            cell.nameLabel.font = .systemFont(ofSize: 13, weight: .bold)
        } else {
            cell.nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionView Delegate
extension ServicesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vcType = services[indexPath.item].vc
        
        navigationController?.pushViewController(vcType(), animated: true)
    }
    
}
