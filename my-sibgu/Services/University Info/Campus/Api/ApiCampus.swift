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
    
//    static func joinToUnion(unionId: Int) -> URLRequest {
//        
//    }
    
}
