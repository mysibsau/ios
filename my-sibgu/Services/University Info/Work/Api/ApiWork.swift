//
//  ApiWork.swift
//  my-sibgu
//
//  Created by art-off on 06.02.2021.
//

import Foundation

class ApiWork{
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func allVacancies() -> URLRequest {
//        let lang = Localize.currentLanguage
        let urlRequest = URLRequest(url: URL(string: "\(address)/work/vacancies/")!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
    }
    
}
