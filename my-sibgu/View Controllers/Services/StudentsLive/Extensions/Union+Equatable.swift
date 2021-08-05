//
//  Union+Equatable.swift
//  my-sibgu
//
//  Created by art-off on 09.01.2021.
//

import Foundation

extension Union: Equatable {
    
    static func == (lhs: Union, rhs: Union) -> Bool {
        let id = lhs.id == rhs.id
        let name = lhs.name == rhs.name
        let shortName = lhs.shortName == rhs.shortName
        let leaderRank = lhs.leaderRank == rhs.leaderRank
        let leaderName = lhs.leaderName == rhs.leaderName
        let address = lhs.address == rhs.address
        let phone = lhs.phone == rhs.phone
        let groupVkUrl = lhs.groupVkUrl == rhs.groupVkUrl
        let leaderPageVkUrl = lhs.leaderPageVkUrl == rhs.leaderPageVkUrl
        let about = lhs.about == rhs.about
        
        let logoUrl = lhs.logoUrl == rhs.logoUrl
        let leaderPhotoUrl = lhs.leaderPhotoUrl == rhs.leaderPhotoUrl
        
        return id && name && shortName && leaderRank && leaderName && address && phone && groupVkUrl && leaderPageVkUrl && about && logoUrl && leaderPhotoUrl
    }

}
