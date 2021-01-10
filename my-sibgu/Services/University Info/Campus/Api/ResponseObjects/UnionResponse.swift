//
//  UnionResponse.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class UnionResponse: Decodable {
    
    let id: Int
    let name: String
    let shortName: String?
    let leaderRank: String?
    let leaderName: String
    let address: String
    let phone: String
    let groupVkUrl: String
    let leaderPageVkUrl: String?
    let about: String?
    let rank: Int
    
    // ссылка на лого
    let logoUrl: String
    // ссылка на фотку председателя
    let leaderPhotoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
        case leaderRank = "leader_rank"
        case leaderName = "fio"
        case address
        case phone
        case groupVkUrl = "group_vk"
        case leaderPageVkUrl = "page_vk"
        case logoUrl = "logo"
        case leaderPhotoUrl = "photo"
        case about
        case rank
    }
    
}

extension UnionResponse: ConvertableToRealm {

    func converteToRealm() -> RUnion {
        let u = RUnion()
        u.id = self.id
        u.name = self.name
        u.shortName = self.shortName
        u.leaderRank = self.leaderRank
        u.leaderName = self.leaderName
        u.address = self.address
        u.phone = self.phone
        u.groupVkUrl = self.groupVkUrl
        u.leaderPageVkUrl = self.leaderPageVkUrl
        u.logoUrl = self.logoUrl
        u.leaderPhotoUrl = self.leaderPhotoUrl
        u.about = self.about
        u.rank = self.rank
        return u
    }
    
}
