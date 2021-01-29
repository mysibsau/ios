//
//  ServicesCollectionViewController.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import UIKit

private typealias ServicesDataSource = [(image: UIImage, color: UIColor, name: String, vc: UIViewController.Type)]

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
                UIImage(systemName: "map")!, UIColor.Pallete.sibsuBlue,
                "Строения", BuildingsViewController.self
            ),
            (
                UIImage(named: "institute")!, UIColor.Pallete.gray,
                "Институты", InstitutionsViewController.self),
            (
                UIImage(systemName: "cart")!, UIColor.Pallete.orange,
                "Онлайн каталог", UIViewController.self
            ),
            (
                UIImage(named: "feedback")!, UIColor.Pallete.sibsuGreen,
                "Обратная связь", SurveysTableViewController.self
            ),
            (
                UIImage(systemName: "person.2")!, UIColor.Pallete.green,
                "Студ. жизнь", vc: UnionsTableViewController.self
            ),
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
        services[2].name = "online.catalog".localized(using: tableName)
        services[3].name = "feedback".localized(using: tableName)
        services[4].name = "student.life".localized(using: tableName)
        
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
        cell.imageView.image = service.image.withRenderingMode(.alwaysTemplate)
        cell.tintColor = service.color
        cell.nameLabel.text = service.name
        
        return cell
    }
    
}

// MARK: - UICollectionView Delegate
extension ServicesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vcType = services[indexPath.item].vc
        
        navigationController?.pushViewController(vcType.init(), animated: true)
    }
    
}
