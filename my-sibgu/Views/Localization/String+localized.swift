//
//  String+localized.swift
//  my-sibgu
//
//  Created by art-off on 20.01.2021.
//

import Foundation

extension String {
    
    func localized(using tableName: String? = nil,
                   in bundle: Bundle = .main) -> String {
        
        if let path = bundle.path(forResource: Localize.currentLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: "*****\(self)*****", table: tableName)
        }
        return self
    }
    
}
