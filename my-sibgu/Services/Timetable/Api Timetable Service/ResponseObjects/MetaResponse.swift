//
//  MetaResponse.swift
//  my-sibgu
//
//  Created by art-off on 15.01.2021.
//

import Foundation

class MetaResponse: Decodable {
    
    let groupsHash: String
    let professorHash: String
    let placesHash: String
    let currentWeek: Int
    
    enum CodingKeys: String, CodingKey {
        case groupsHash = "groups_hash"
        case professorHash = "teachers_hash"
        case placesHash = "places_hash"
        case currentWeek = "current_week"
    }
    
}
