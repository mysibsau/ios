//
//  ServicesCollectionViewController.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import UIKit

private typealias ServicesDataSource = [(image: UIImage, name: String, vc: UIViewController.Type)]

class ServicesCollectionViewController: UICollectionViewController {
    
    private var services: ServicesDataSource!
    
    
    private let spacing: CGFloat = 10
    private lazy var itemWidth = CollectionViewHelper.getItemWidth(
        byCollectionViewWidth: collectionView.bounds.width,
        numberItemsPerLine: 3,
        spacing: spacing)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        collectionView.register(
            ServiceCollectionViewCell.self,
            forCellWithReuseIdentifier: ServiceCollectionViewCell.reuseIdentifier
        )
        
        services = [
            (UIImage(named: "main_logo")!, "Строения", vc: BuildingsViewController.self),
            (UIImage(named: "main_logo")!, "Институты", vc: InstitutionsViewController.self),
            (UIImage(named: "main_logo")!, "Онлайн каталог", vc: UIViewController.self),
            (UIImage(named: "main_logo")!, "Обратная связь", vc: SurveysTableViewController.self),
            (UIImage(named: "main_logo")!, "Студ. жизнь", vc: UnionsTableViewController.self),
        ]
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Сервисы")
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
        cell.imageView.image = service.image
        cell.nameLabel.text = service.name
        cell.updateSize(widthAndHeidth: itemWidth)
        
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

// MARK: - UICollectionView Delegate Floa Layout
extension ServicesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
}
