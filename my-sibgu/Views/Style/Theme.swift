//
//  Theme.swift
//  my-sibgu
//
//  Created by art-off on 19.01.2021.
//

import UIKit

enum Theme: Int, CaseIterable {
    
    case light = 0
    case dark
    
}

extension Theme {
    
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.system.app-theme", defaultValue: Theme.light.rawValue)
    private static var appTheme: Int
    
    func save() {
        Theme.appTheme = self.rawValue
    }
    
    static var current: Theme {
        Theme(rawValue: appTheme) ?? .light
    }
    
}

extension Theme {
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    func setActive() {
        // Сохраняем текущую тему в UD
        save()
        
        // Меняем стиль всех окон приложения
        UIApplication.shared.windows
            .forEach {
                $0.overrideUserInterfaceStyle = userInterfaceStyle
            }
    }
    
}
