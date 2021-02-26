//
//  CollectionViewHelper.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import UIKit

class CollectionViewHelper {
    
    static func getItemWidth(byCollectionViewWidth collectionViewWidth: CGFloat,
                             numberItemsPerLine: Int,
                             spacing: CGFloat) -> CGFloat {
        
        let spaceForItemsWithoutSpacing = Int(collectionViewWidth - CGFloat(numberItemsPerLine + 1) * spacing)
        return CGFloat(Int(spaceForItemsWithoutSpacing / numberItemsPerLine))
    }
    
    static func getViewWithImage(image: UIImage, backgroundColor: UIColor, imageColor: UIColor) -> UIView {
        let v = UIView()
        
        let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        
        v.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        v.layer.cornerRadius = 10
        v.backgroundColor = backgroundColor
        v.tintColor = imageColor
        
        return v
    }
    
    static func getFeedbackView(backgroundColor: UIColor, imageColor: UIColor) -> UIView {
        let v = UIView()
        
        let wrapView = UIView()
        
        let lineView1 = UIView()
        let lineView2 = UIView()
        let lineView3 = UIView()
        
        wrapView.addSubview(lineView1)
        wrapView.addSubview(lineView2)
        wrapView.addSubview(lineView3)
        
        lineView1.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.85)
            make.width.equalToSuperview().dividedBy(3).offset(-4)
        }
        lineView2.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalTo(lineView1.snp.trailing).offset(6)
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3).offset(-4)
        }
        lineView3.snp.makeConstraints { make in
            make.leading.equalTo(lineView2.snp.trailing).offset(6)
            make.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
            make.width.equalToSuperview().dividedBy(3).offset(-4)
        }
        
        v.addSubview(wrapView)
        wrapView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        lineView1.backgroundColor = imageColor
        lineView2.backgroundColor = imageColor
        lineView3.backgroundColor = imageColor
        lineView1.layer.cornerRadius = 2
        lineView2.layer.cornerRadius = 2
        lineView3.layer.cornerRadius = 2
        v.backgroundColor = backgroundColor
        v.layer.cornerRadius = 10
        
        return v
    }
    
    static func getFAQView(backgroundColor: UIColor, imageColor: UIColor) -> UIView {
        let v = UIView()
        
        let label = UILabel()
        label.text = "?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 47, weight: .bold)
        
        v.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.textColor = imageColor
        v.backgroundColor = backgroundColor
        v.layer.cornerRadius = 10
        
        return v
    }
    
}
