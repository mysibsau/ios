//
//  UIWindow+initTheme.swift
//  my-sibgu
//
//  Created by art-off on 19.01.2021.
//

import UIKit

extension UIWindow {
    
    func initTheme() {
        overrideUserInterfaceStyle = Theme.current.userInterfaceStyle
    }
    
}
