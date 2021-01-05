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
        return URL(string: "\(address)/campus/buildings/")!
    }
    
    static func institutes() -> URL {
        return URL(string: "\(address)/campus/institutes/")!
    }
    
    static func unions() -> URL {
        return URL(string: "\(address)/campus/unions/")!
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
