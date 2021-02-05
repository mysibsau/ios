//
//  SportClubResponse.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import Foundation

class SportClubResponse: Decodable {
    
    let id: Int
    let name: String
    let fio: String
    let phone: String
    let address: String
    let dates: String
    
    let logoUrl: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fio
        case phone
        case address
        case dates
        case logoUrl = "logo"
    }
    
}

extension SportClubResponse: ConvertableToRealm {

    func converteToRealm() -> RSportClub {
        let sportClub = RSportClub()
        sportClub.id = id
        sportClub.name = name
        sportClub.fio = fio
        sportClub.phone = phone
        sportClub.address = address
        sportClub.dates = dates
        sportClub.logoUrl = logoUrl
        return sportClub
    }
    
}
