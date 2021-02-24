//
//  EntityType.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

enum EntitiesType: Int, Codable {
    case group = 0
    case professor = 1
    case place = 2
    
    var raw: String {
        switch self {
        case .group: return "group"
        case .professor: return "professor"
        case .place: return "place"
        }
    }
}
