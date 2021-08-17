//
//  RequestWithDefaultHeaderParams.swift
//  my-sibgu
//
//  Created by Artem Rylov on 16.08.2021.
//

import Foundation

// MARK: - HeaderDefalutParams
enum HeaderDefaultParam: DictableType {
    
    case bearerToken
    
    var dict: [String: String] {
        switch self {
        case .bearerToken:
            if let token = UserService().getCurrUser()?.token {
                return ["Authorization": "Bearer \(token)"]
            } else {
                print("REQUEST HEADER - Can't to add `bearerToken` because user is not logged in")
                return [:]
            }
        }
    }
}

// MARK: - Request with default pamams
protocol RequestWithDefaultHeaderParams {
    var bearerToken: Bool { get }
}

extension RequestWithDefaultHeaderParams {
    var bearerToken: Bool { true }
}

extension Request where Self: RequestWithDefaultHeaderParams {
    
    var finalHeaderParams: [String: String]? {
        guard headerParams != nil || bearerToken else { return nil }
        
        var defaultParams: [HeaderDefaultParam] = []
        if bearerToken { defaultParams.append(.bearerToken) }
        
        return (headerParams ?? [:])
            + allDefaultParamsDict(by: defaultParams)
    }
}
