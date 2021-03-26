//
//  RoomStructView.swift
//  my-sibgu
//
//  Created by art-off on 05.03.2021.
//

import UIKit

protocol RoomStructViewDelegate {
    func didSelectTicket(ticket: RoomItem, allow: (Bool) -> Void)
    func didDeselectTicket(ticket: RoomItem)
}


class RoomStructView: UIView {
    
    var delegate: RoomStructViewDelegate?
    
    
    var items: [[(value: RoomItem?, selected: Bool)]]!
    var itemWidth: CGFloat!
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    
    var pricesAndColors: [(price: Double, color: UIColor)] = []

    var pricesCollectionView: UICollectionView!
    var structCollectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(items: [[RoomItem?]], viewWidth: CGFloat, viewHeight: CGFloat) {
        self.init()
        
        self.items = items.map { $0.map { ($0, false) } }
        self.viewWidth = viewWidth
        self.viewHeight = viewHeight
        
        fillPricesAndColors(fromItems: items)
        setupPricesCollectionView()
        setupStructCollectionView()
    }
    
    private func fillPricesAndColors(fromItems items: [[RoomItem?]]) {
        for row in items {
            for item in row {
                if let item = item, item.price > 0 {
                    let index = pricesAndColors.firstIndex(where: { $0.price == item.price })
                    
                    if index == nil {
                        pricesAndColors.append((item.price, getColor(forIndex: pricesAndColors.count)))
                    }
                }
            }
        }
    }
    
    private func getColor(forIndex index: Int) -> UIColor {
        let index = index % UIColor.Pallete.Special.priceColors.count
        
        return UIColor.Pallete.Special.priceColors[index]
    }
    
    private func setupPricesCollectionView() {
        let cellWidth: CGFloat = 100
        let cellSpacing: CGFloat = 5
        let topBottomInsetSpacing: CGFloat = 10
        
        let leftRightInsetSpacing: CGFloat
        
        if pricesAndColors.count <= 3 {
            let allWidth = cellWidth * CGFloat(pricesAndColors.count)
            let allSpacing = cellSpacing * CGFloat(pricesAndColors.count - 1)
            leftRightInsetSpacing = (viewWidth - allWidth - allSpacing) / 2
        } else {
            let allWidth = cellWidth * 3
            let allSpacing = cellSpacing * 2
            leftRightInsetSpacing = (viewWidth - allWidth - allSpacing) / 2
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: 20)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: topBottomInsetSpacing, left: leftRightInsetSpacing, bottom: topBottomInsetSpacing, right: leftRightInsetSpacing)
        
        pricesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 100), collectionViewLayout: layout)
        pricesCollectionView.isScrollEnabled = false
        
        pricesCollectionView.register(
            TicketPriceCollectionViewCell.self,
            forCellWithReuseIdentifier: TicketPriceCollectionViewCell.reuseIdentifier
        )
        
        addSubview(pricesCollectionView)
        pricesCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        pricesCollectionView.dataSource = self
        pricesCollectionView.delegate = self
        
        pricesCollectionView.reloadData()
        
        pricesCollectionView.backgroundColor = .clear
    }
    
    private func setupStructCollectionView() {
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
        self.itemWidth = itemWidth
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: topBottomInsetSpacing, left: leftRightInsetSpacing, bottom: topBottomInsetSpacing, right: leftRightInsetSpacing)
        
        structCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), collectionViewLayout: layout)
        structCollectionView.isScrollEnabled = false
        
        structCollectionView.register(
            RoomPlaceCollectionViewCell.self,
            forCellWithReuseIdentifier: RoomPlaceCollectionViewCell.reuseIdentifier)
        
        addSubview(structCollectionView)
        structCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.trailing.leading.bottom.equalToSuperview()
        }
        structCollectionView.dataSource = self
        structCollectionView.delegate = self
        
        structCollectionView.reloadData()
        
        structCollectionView.backgroundColor = .clear
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
        if collectionView === self.structCollectionView {
            return items.count * items.first!.count
        } else {
            return pricesAndColors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView === self.structCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RoomPlaceCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! RoomPlaceCollectionViewCell
            
            let lenght = items.first!.count
            let index1 = indexPath.item / lenght
            let index2 = indexPath.item % lenght
            
            let item = items[index1][index2]
            
            if let value = item.value {
                cell.isHidden = false
                
                if value.price < 0 {
                    cell.backgroundColor = UIColor.Pallete.gray
                    cell.isUserInteractionEnabled = false
                } else {
                    cell.isUserInteractionEnabled = true
                    let colorIndex = pricesAndColors.firstIndex(where: { $0.price == value.price })
                    if let colorIndex = colorIndex {
                        cell.backgroundColor = pricesAndColors[colorIndex].color
                    } else {
                        cell.backgroundColor = .yellow
                    }
                }
            } else {
                cell.isHidden = true
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TicketPriceCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! TicketPriceCollectionViewCell
            
            let priceAndColor = pricesAndColors[indexPath.item]
            
            let price: String
            // Если Int
            if floor(priceAndColor.price) == priceAndColor.price {
                price = String(Int(priceAndColor.price))
            } else {
                price = String(priceAndColor.price)
            }
            
            cell.textLabel.text = " - \(price) ₽"
            cell.colorView.backgroundColor = priceAndColor.color
            
            return cell
        }
    }
}

extension RoomStructView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView === self.structCollectionView else { return }
        
        let lenght = items.first!.count
        let index1 = indexPath.item / lenght
        let index2 = indexPath.item % lenght
        
        let item = items[index1][index2]
        
        guard let value = item.value else { return }
        
        let cell = collectionView.cellForItem(at: indexPath) as! RoomPlaceCollectionViewCell
        
        if item.selected {
            delegate?.didDeselectTicket(ticket: value)
            cell.circleIsHide(true, diametr: itemWidth)
            items[index1][index2].selected = false
        } else {
            delegate?.didSelectTicket(ticket: value, allow: { isAllow in
                guard isAllow else { return }
                cell.circleIsHide(false, diametr: itemWidth)
                items[index1][index2].selected = true
            })
        }
    }
}
