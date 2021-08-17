//
//  RequestWithDefaultParams.swift
//  my-sibgu
//
//  Created by Artem Rylov on 10.08.2021.
//

import Foundation

// MARK: - QueryDefalutParams
enum QueryDefaultParam: DictableType {
    
    case language
    
    var dict: [String: String] {
        switch self {
        case .language: return ["language": Localize.currentLanguage]
        }
    }
}

// MARK: - Request with default pamams
protocol RequestWithDefaultQueryParams {
    var language: Bool { get }
}

extension RequestWithDefaultQueryParams {
    var language: Bool { true }
}

extension Request where Self: RequestWithDefaultQueryParams {
    
    var finalQueryParams: [String: String]? {
        guard queryParams != nil || language else { return nil }
        
        var defaultParams: [QueryDefaultParam] = []
        if language { defaultParams.append(.language) }
        
        return (queryParams ?? [:])
            + allDefaultParamsDict(by: defaultParams)
    }
}
