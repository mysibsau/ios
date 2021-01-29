//
//  PlaceResponse.swift
//  my-sibgu
//
//  Created by art-off on 27.01.2021.
//

import Foundation

class PlaceResponse: Decodable {
    
    let id: Int
    let name: String
    let address: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
    }
    
}
