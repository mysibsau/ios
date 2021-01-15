//
//  SubgroupResponse.swift
//  my-sibgu
//
//  Created by art-off on 15.01.2021.
//

import Foundation

class SubgroupResponse: Decodable {
    
    let number: Int
    let subject: String
    let type: Int
    
    let group: String
    let groupId: Int
    
    let place: String
    let placeId: Int
    
    let professor: String
    let professorId: Int
    
    
    enum CodingKeys: String, CodingKey {
        case number = "num"
        case subject = "name"
        case type
        case group
        case groupId = "group_id"
        case place
        case placeId = "place_id"
        case professor = "teacher"
        case professorId = "teacher_id"
    }
    
}
