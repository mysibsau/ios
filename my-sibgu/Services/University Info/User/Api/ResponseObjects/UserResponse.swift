//
//  UserResponse.swift
//  my-sibgu
//
//  Created by art-off on 10.02.2021.
//

import Foundation

class UserResponse: Decodable {
    
    let token: String
    let fio: String
    let averageRating: Double
    let group: String
    let zachotka: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case fio = "FIO"
        case averageRating = "averga"
        case group
        case zachotka
    }
    
}

extension UserResponse: ConvertableToRealm {

    func converteToRealm() -> RUser {
        let u = RUser()
        u.token = token
        u.fio = fio
        u.averageRating = averageRating
        u.group = group
        u.zachotka = zachotka
        return u
    }
    
}
