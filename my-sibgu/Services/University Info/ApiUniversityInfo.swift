//
//  ApiUniversityInfo.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

struct ApiUniversityInfo {
    
    static let address = "http://193.187.174.224"
    
    static let addressByVersion = "\(address)/v2"
    
    static func download(with postfix: String) -> URL {
        return URL(string: "\(address)\(postfix)"
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
}

