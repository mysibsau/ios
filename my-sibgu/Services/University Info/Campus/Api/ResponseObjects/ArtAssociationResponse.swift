//
//  ArtAssociationResponse.swift
//  my-sibgu
//
//  Created by Artem Rylov on 07.08.2021.
//

import Foundation

struct ArtAssociationResponse: Decodable {
    
    let id: Int
    let logo: String
    let name: String
    let description: String
    let contacts: String
}

extension ArtAssociationResponse: ConvertableToRealm {

    func converteToRealm() -> RArtAssociated {
        let rAA = RArtAssociated()
        rAA.id = id
        rAA.name = name
        rAA.logo = logo
        rAA.description1 = description
        rAA.contacts = contacts
        return rAA
    }
}
