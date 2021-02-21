//
//  ApiCafeteria.swift
//  my-sibgu
//
//  Created by art-off on 21.02.2021.
//

import Foundation

class ApiCafeteria {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func allCafeterias() -> URLRequest {
        let urlRequest = URLRequest(url: URL(string: "\(address)/menu/all/")!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
    }
    
}
