//
//  ApiCampus.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

struct ApiCampus {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func buildings() -> URL {
        let lang = Localize.currentLanguage
        return URL(string: "\(address)/campus/buildings/?language=\(lang)")!
    }
    
    static func institutes() -> URL {
        let lang = Localize.currentLanguage
        return URL(string: "\(address)/campus/institutes/?language=\(lang)")!
    }
    
    // MARK: Student Life
    static func unions() -> URL {
        let lang = Localize.currentLanguage
        return URL(string: "\(address)/campus/unions/?language=\(lang)")!
    }
    
    static func sportClubs() -> URL {
        let lang = Localize.currentLanguage
        return URL(string: "\(address)/campus/sport_clubs/?language=\(lang)")!
    }
    
    static func desingOffices() -> URL {
        let lang = Localize.currentLanguage
        return URL(string: "\(address)/campus/desing_offices/?language=\(lang)")!
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
