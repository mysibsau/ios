//
//  ApiLibrary.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import Foundation

class ApiLibrary {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func books(by searchText: String) -> URLRequest {
        let urlRequest = URLRequest(url: URL(string: "\(address)/library/all_books/?q=\(searchText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
    }
    
}
