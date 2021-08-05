//
//  SportClub+Equatable.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import Foundation

extension SportClub: Equatable {
    
    static func == (lhs: SportClub, rhs: SportClub) -> Bool {
        let id = lhs.id == rhs.id
        let name = lhs.name == rhs.name
        let fio = lhs.fio == rhs.fio
        let address = lhs.address == rhs.address
        let phone = lhs.phone == rhs.phone
        let logoUrl = lhs.logoUrl == rhs.logoUrl
        
        return id && name && fio && address && phone && logoUrl
    }
    
}
