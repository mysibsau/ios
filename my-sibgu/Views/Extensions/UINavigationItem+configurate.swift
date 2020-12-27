//
//  UINavigationItem+configurate.swift
//  my-sibgu
//
//  Created by art-off on 26.11.2020.
//

import UIKit
import SnapKit

extension UINavigationItem {
    
    func configurate() {
        self.leftItemsSupplementBackButton = true
        self.backButtonTitle = ""
    }
    
    // MARK: - Set Left Side
    func setBarLeftMainLogoAndLeftTitle(title: String) {
        let logoItem = _mainLogo()
        let leftTitle = _leftTitle(title: title)
        
        self.leftBarButtonItems = [logoItem, leftTitle]
    }
    
    func setBarLeftMainLogo() {
        let logoItem = _mainLogo()
        
        self.leftBarButtonItem = logoItem
    }
    
    func setLeftTitle(title: String) {
        let leftTitle = _leftTitle(title: title)
        
        self.leftBarButtonItem = leftTitle
    }
    
    func setCenterTitle(title: String) {
        let titleView = _centerTitle(title: title)
        
        self.titleView = titleView
    }
    
    func setLeftExitButtonAndLeftTitle(title: String, vc: PopableViewController) {
        self.leftItemsSupplementBackButton = false

        let exitButton = UIBarButtonItem(image: UIImage(systemName: "escape"), style: .plain, target: vc, action: #selector(vc.popViewController))
        exitButton.tintColor = .gray
        
        let leftTitle = _leftTitle(title: title)
        
        self.leftBarButtonItems = [exitButton, leftTitle]
    }
    
    
    // MARK: - Private Method
    private func _image(withName name: String, isSystem: Bool = false, color: UIColor? = nil) -> UIBarButtonItem {
        let imageView: UIImageView
        if isSystem {
            imageView = UIImageView(image: UIImage(systemName: name))
            imageView.snp.makeConstraints { make in
                make.size.equalTo(30)
            }
        } else {
            imageView = UIImageView(image: UIImage(named: name))
            imageView.snp.makeConstraints { make in
                make.size.equalTo(40)
            }
        }
        imageView.contentMode = .scaleAspectFit
        
        if let color = color {
            imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        }
        
        let logoItem = UIBarButtonItem(customView: imageView)
        
        return logoItem
    }
    
    private func _mainLogo() -> UIBarButtonItem {
        return _image(withName: "main_logo")
    }
    
    private func _leftTitle(title: String) -> UIBarButtonItem {
        let leftTitle = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        leftTitle.tintColor = .gray
        leftTitle.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        // Это спасает от того, что title растягивается на весь нав бар, теперь он точички ставит если че
        leftTitle.width = 30
        
        return leftTitle
    }
    
    private func _centerTitle(title: String) -> UIView {
        let centerTitle = UILabel()
        centerTitle.text = title
        centerTitle.textColor = .gray
        centerTitle.font = UIFont.boldSystemFont(ofSize: 24)
        
        let titleView = UIView()
        titleView.addSubview(centerTitle)
        centerTitle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return titleView
    }
    
}
