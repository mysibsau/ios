//
//  Theme.swift
//  my-sibgu
//
//  Created by art-off on 19.01.2021.
//

import UIKit

enum Theme: Int, CaseIterable {
    
    case system = 0
    case light
    case dark
    
//    static var themeWindow = ThemeWindow()
    
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

//extension Theme {
//    
//    var userInterfaceStyle: UIUserInterfaceStyle {
//        switch self {
//        case .light: return .light
//        case .dark: return .dark
//        case .system:
//            return Theme.themeWindow.traitCollection.userInterfaceStyle
////            let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
////            let delegate = windowScene.delegate as! SceneDelegate
////            return delegate.themeWindow.traitCollection.userInterfaceStyle
//        }
//    }
//    
//    func setActive() {
//        // Сохраняем текущую тему в UD
//        save()
//        
//        // Меняем стиль всех окон приложения
//        UIApplication.shared.windows
//            .filter { $0 != Theme.themeWindow }
//            .forEach { $0.overrideUserInterfaceStyle = userInterfaceStyle }
//    }
//    
//}
