//
//  SavedEntity.swift
//  my-sibgu
//
//  Created by art-off on 24.02.2021.
//

import Foundation

struct SavedEntity: Codable {
    let type: EntitiesType
    let id: Int
}

enum TimetableEntity {
    
    case group(Group)
    case professor(Professor)
    case place(Place)
    
}
