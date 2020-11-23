//
//  EntityType.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

enum EntitiesType: String {
    case group
    case professor
    case place
    
    var raw: String {
        switch self {
        case .group: return "group"
        case .professor: return "professor"
        case .place: return "place"
        }
    }
}
