//
//  CatalogCollectionViewController.swift
//  my-sibgu
//
//  Created by art-off on 01.02.2021.
//

import UIKit

private typealias GoodsDataSource = [(imageUrl: URL, name: String, price: Double)]

class CatalogCollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    private var goods: GoodsDataSource!
    
    
    private let spacing: CGFloat = 15
    private lazy var itemWidth = CollectionViewHelper.getItemWidth(
        byCollectionViewWidth: view.bounds.width,
        numberItemsPerLine: 2,
        spacing: spacing)
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }()
    
    
    // MARK: - Life Circle
    override func loadView() {
        super.loadView()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        collectionView.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        collectionView.register(
            GoodCollectionViewCell.self,
            forCellWithReuseIdentifier: GoodCollectionViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Онлайн каталог")
    }
    
    @objc
    private func updateText() {
        let tableName = "OnlineShop"
        
        navigationItem.setBarLeftMainLogoAndLeftTitle(title: "nav.bar.title".localized(using: tableName))
    }
    
}

// MARK: - UICollectionView Data Source
extension CatalogCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GoodCollectionViewCell.reuseIdentifier,
            for: indexPath) as! GoodCollectionViewCell
        
        // Configure
        
        return cell
    }
    
}

// MARK: - UICollectionView Delegate
extension CatalogCollectionViewController {
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vcType = services[indexPath.item].vc
//        
//        navigationController?.pushViewController(vcType.init(), animated: true)
//    }
    
}
