//
//  UINavigationController+configurateNavigationBar.swift
//  my-sibgu
//
//  Created by art-off on 26.11.2020.
//

import UIKit

extension UINavigationController {
    
    func configurateNavigationBar() {
        self.navigationBar.isTranslucent = true
        self.navigationBar.makeShadow(
            color: .black,
            opacity: 0.2,
            shadowOffser: CGSize(width: 0, height: 2),
            radius: 3
        )
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}
