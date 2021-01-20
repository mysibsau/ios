//
//  Localize.swift
//  my-sibgu
//
//  Created by art-off on 20.01.2021.
//

import Foundation

// MARK:  Класс для локализации
class Localize {
    
    // Дефолтный язык, используемый в приложении
    static let appDefalutLanguage = "en"
    
    
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.system.firstWeekIsEven", defaultValue: String?(nil))
    private static var _currentLanguage: String?
    
    
    // MARK: - Set and Get Current Language
    static func setCurrentLanguage(_ language: String) {
        // Если такой язык не поддерживается - ставим стандартный
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage
        
        // Сохраняем в UD и отправляем всем пост, что язык обновился
        if selectedLanguage != currentLanguage {
            _currentLanguage = selectedLanguage
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    static var currentLanguage: String {
        guard let currLanguage = _currentLanguage else {
            return defaultLanguage
        }
        return currLanguage
    }
    
    // MARK: - Other Methods
    static func availableLanguages(excludeBase: Bool = true) -> [String] {
        var availableLanguages = Bundle.main.localizations
        if excludeBase, let indexOfBase = availableLanguages.firstIndex(of: "Base") {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    static var defaultLanguage: String {
        // Если нет предпочитаемого языка, то возвращаем стандартный язык
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return appDefalutLanguage
        }
        
        // Если предпочитаемый язык не поддерживается - возвращаем стардартный
        if availableLanguages().contains(preferredLanguage) {
            return preferredLanguage
        } else {
            return appDefalutLanguage
        }
    }
    
    static func displayName(for language: String) -> String {
        let locale = NSLocale(localeIdentifier: language)
        // Если такое есть - возвращаем
        if let displayName = locale.displayName(forKey: .identifier, value: language) {
            return displayName.capitalizinFirstLetter()
        }
        // Иначе возвращаем просто идентификатор
        return currentLanguage
    }
    
    static func resetCurrentLanguageToDefault() {
        setCurrentLanguage(defaultLanguage)
    }
    
    static func resetCurrentLanguageToSystem() {
        _currentLanguage = nil
    }
    
}
