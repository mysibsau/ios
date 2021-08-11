//
//  RequestWithDefaultParams.swift
//  my-sibgu
//
//  Created by Artem Rylov on 10.08.2021.
//

import Foundation

// MARK: - QueryDefalutParams
enum QueryDefaultParam {
    
    case language
    
    var dict: [String: String] {
        switch self {
        case .language: return ["language": Localize.currentLanguage]
        }
    }
}

// MARK: - Request with default pamams
protocol RequestWithDefaultParams {
    var language: Bool { get }
}

extension RequestWithDefaultParams {
    var language: Bool { true }
}

extension Request where Self: RequestWithDefaultParams {
    
    var finalQueryParams: [String: String]? {
        guard queryParams != nil || [language].allSatisfy({ $0 }) else { return nil }
        
        var defaultParams: [QueryDefaultParam] = []
        if language { defaultParams.append(.language) }
        
        return (queryParams ?? [:])
            + QueryDefaultParam.allDefaultParamsDict(by: defaultParams)
    }
}

// MARK: - Helper
extension QueryDefaultParam {
    
    static func allDefaultParamsDict(by params: [QueryDefaultParam]) -> [String: String] {
        var dict: [String: String] = [:]
        params.forEach {
            dict += $0.dict
        }
        return dict
    }
}
