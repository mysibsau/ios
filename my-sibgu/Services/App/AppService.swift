//
//  AppService.swift
//  my-sibgu
//
//  Created by art-off on 26.03.2021.
//

import Foundation

class AppService {
    
    static func appVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return version ?? "2.0"
    }
    
}
