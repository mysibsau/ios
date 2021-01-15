//
//  GroupResponse.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class GroupResponse: Decodable {
    
    let id: Int
    let name: String
//    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
//        case email = "mail"
    }
    
}
