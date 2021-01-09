//
//  Buildings+Equatable.swift
//  my-sibgu
//
//  Created by art-off on 09.01.2021.
//

import Foundation

extension Building: Equatable {
    
    static func == (lhs: Building, rhs: Building) -> Bool {
        let name = lhs.name == rhs.name
        let type = lhs.type == rhs.type
        let address = lhs.address == rhs.address
        let coast = lhs.coast == rhs.coast
        let urlTo2gis = lhs.urlTo2gis == rhs.urlTo2gis
        
        return name && type && address && coast && urlTo2gis
    }
    
}
