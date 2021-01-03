//
//  Building.swift
//  my-sibgu
//
//  Created by art-off on 17.11.2020.
//

import Foundation

struct Building {
    
    let name: String
    let type: String
    let address: String
    let coast: Coast
    let urlTo2gis: URL
    
    
    enum Coast {
        case left
        case right
    }
    
}


