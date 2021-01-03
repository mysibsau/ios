//
//  BudlingResponse.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation
import RealmSwift

class BuidlingResponse: Decodable {
    
    let name: String
    let type: String
    let address: String
    let coast: Int
    let urlTo2gis: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case address
        case coast
        case urlTo2gis = "link"
    }
    
}

extension BuidlingResponse: ConvertableToRealm {

    func converteToRealm() -> RBuilding {
        let b = RBuilding()
        b.name = self.name
        b.type = self.type
        b.address = self.address
        b.coast = self.coast
        b.urlTo2gis = self.urlTo2gis
        return b
    }
    
}
