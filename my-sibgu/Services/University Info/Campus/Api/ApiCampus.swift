//
//  ApiCampus.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

struct ApiCampus {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func buildings() -> URLRequest {
        let lang = Localize.currentLanguage
        let urlRequest = URLRequest(url: URL(string: "\(address)/campus/buildings/?language=\(lang)")!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
    }
    
    static func institutes() -> URLRequest {
        let lang = Localize.currentLanguage
        let urlRequest = URLRequest(url: URL(string: "\(address)/campus/institutes/?language=\(lang)")!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
    }
    
    // MARK: Student Life
    static func unions() -> URLRequest {
        let lang = Localize.currentLanguage
        let urlRequest = URLRequest(url: URL(string: "\(address)/campus/unions/?language=\(lang)")!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
    }
    
    static func sportClubs() -> URLRequest {
        let lang = Localize.currentLanguage
        let urlRequest = URLRequest(url: URL(string: "\(address)/campus/sport_clubs/?language=\(lang)")!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
        
    }
    
    static func desingOffices() -> URLRequest {
        let lang = Localize.currentLanguage
        let urlRequest = URLRequest(url: URL(string: "\(address)/campus/design_offices/?language=\(lang)")!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
    }
    
    static func joinToUnion(unionId: Int, fio: String, institute: String, group: String, vk: String, hobby: String, reason: String) -> URLRequest {
        let parameters = [
            "fio": fio,
            "institute": institute,
            "group": group,
            "vk": vk,
            "hobby": hobby,
            "reason": reason
        ]
        
        let request = ApiUniversityInfo.multipartRequest(withUrl: URL(string: "\(address)/campus/unions/join/\(unionId)/")!, parameters: parameters)
        
        return request
    }
    
}
