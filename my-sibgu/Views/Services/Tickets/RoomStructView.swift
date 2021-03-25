//
//  RoomStructView.swift
//  my-sibgu
//
//  Created by art-off on 05.03.2021.
//

import UIKit

class RoomStructView: UIView {
    
    var items: [[RoomItem?]]!
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!

    
    var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(items: [[RoomItem?]], viewWidth: CGFloat, viewHeight: CGFloat) {
        self.init()
        
        self.items = items
        self.viewWidth = viewWidth
        self.viewHeight = viewHeight
        
        let columns = items.first!.count
        let rows = items.count
        
        let cellSpacing: CGFloat = 2
        let insetSpacing: CGFloat = 10
        
        let itemWidthByWidth = getItemWidth(
            byCollectionViewWidth: viewWidth - 2 * insetSpacing,
            numberItemsPerLine: columns,
            spacing: cellSpacing)
        let itemWidthByHeidth = getItemWidth(
            byCollectionViewWidth: viewHeight - 2 * insetSpacing - 100,
            numberItemsPerLine: rows,
            spacing: cellSpacing)
        
        let itemWidth: CGFloat
        
        let leftRightInsetSpacing: CGFloat
        let topBottomInsetSpacing: CGFloat
        
        if itemWidthByWidth < itemWidthByHeidth {
            itemWidth = itemWidthByWidth
            leftRightInsetSpacing = insetSpacing
            topBottomInsetSpacing = (viewHeight - 100 - (CGFloat(rows) * itemWidth) - ((CGFloat(rows) + 1) *  cellSpacing)) / 2
        } else {
            itemWidth = itemWidthByHeidth
            leftRightInsetSpacing = (viewWidth - (CGFloat(columns) * itemWidth) - ((CGFloat(columns) + 1) *  cellSpacing)) / 2
            topBottomInsetSpacing = insetSpacing
        }
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        print(topBottomInsetSpacing, leftRightInsetSpacing)
        layout.sectionInset = UIEdgeInsets(top: topBottomInsetSpacing, left: leftRightInsetSpacing, bottom: topBottomInsetSpacing, right: leftRightInsetSpacing)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        
        collectionView.register(
            RoomPlaceCollectionViewCell.self,
            forCellWithReuseIdentifier: RoomPlaceCollectionViewCell.reuseIdentifier)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.trailing.leading.bottom.equalToSuperview()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.reloadData()
        
        collectionView.backgroundColor = .clear
    }
    
    private func getItemWidth(byCollectionViewWidth collectionViewWidth: CGFloat,
                              numberItemsPerLine: Int,
                              spacing: CGFloat) -> CGFloat {
        
        let spaceForItemsWithoutSpacing = collectionViewWidth - CGFloat(numberItemsPerLine + 1) * spacing
        return CGFloat(spaceForItemsWithoutSpacing / CGFloat(numberItemsPerLine))
    }

}

extension RoomStructView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count * items.first!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RoomPlaceCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! RoomPlaceCollectionViewCell
        
        let lenght = items.first!.count
        let index1 = indexPath.item / lenght
        let index2 = indexPath.item % lenght
        
        let item = items[index1][index2]
        
        if let item = item {
            cell.isHidden = false
                
            cell.backgroundColor = .yellow
        } else {
            cell.isHidden = true
        }
        
        return cell
    }
}

extension RoomStructView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .brown
    }
}
