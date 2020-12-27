//
//  Building.swift
//  my-sibgu
//
//  Created by art-off on 17.11.2020.
//

import Foundation

struct Building {
    
    let coast: Coast
    let name: String
    let urlTo2gis: URL
    
    
    enum Coast {
        case left
        case right
    }
    
}
