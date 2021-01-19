//
//  ThemeWindow.swift
//  my-sibgu
//
//  Created by art-off on 19.01.2021.
//

import UIKit

final class ThemeWindow: UIWindow {
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        // Если текущая тема системная и поменяли оформление в iOS, опять меняем тему на системную.
        // Например: Пользователь поменял светлое оформление на темное.
        print("#######################################################")
        if Theme.current == .system {
            Theme.system.setActive()
        }
    }
}
