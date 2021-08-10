//
//  RequestWithDefaultParams.swift
//  my-sibgu
//
//  Created by Artem Rylov on 10.08.2021.
//

import Foundation

protocol RequestWithDefaultParams {
    var language: Bool { get }
}

extension RequestWithDefaultParams {
    var language: Bool { true }
}

extension Request where Self: RequestWithDefaultParams {
    
    var finalQueryParams: [String: String]? {
        guard queryParams != nil || [language].allSatisfy({ $0 }) else { return nil }
        
        return (queryParams ?? [:])
            + (language ? ["language": Localize.currentLanguage] : [:])
    }
}
