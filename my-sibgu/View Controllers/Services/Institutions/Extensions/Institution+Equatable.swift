//
//  Institution+Equatable.swift
//  my-sibgu
//
//  Created by art-off on 09.01.2021.
//

import Foundation

extension Institute: Equatable {
    
    static func == (lhs: Institute, rhs: Institute) -> Bool {
        let name = lhs.name == rhs.name
        let shortName = lhs.shortName == rhs.shortName
        
        let director = lhs.director == rhs.director
        let departments = lhs.departments == rhs.departments
        let soviet = lhs.soviet == rhs.soviet
        
        return name && shortName && director && departments && soviet
    }
    
}

extension Institute.Director: Equatable {
    
    static func == (lhs: Institute.Director, rhs: Institute.Director) -> Bool {
        let name = lhs.name == rhs.name
        let imageUrl = lhs.imageUrl == rhs.imageUrl
        let address = lhs.address == rhs.address
        let phone = lhs.phone == rhs.phone
        let email = lhs.email == rhs.email
        
        return name && imageUrl && address && phone && email
    }
    
}

extension Institute.Department: Equatable {
    
    static func == (lhs: Institute.Department, rhs: Institute.Department) -> Bool {
        let name = lhs.name == rhs.name
        let leaderName = lhs.leaderName == rhs.leaderName
        let address = lhs.address == rhs.address
        let phone = lhs.phone == rhs.phone
        let email = lhs.email == rhs.email
        
        return name && leaderName && address && phone && email
    }
    
}

extension Institute.Soviet: Equatable {
    
    static func == (lhs: Institute.Soviet, rhs: Institute.Soviet) -> Bool {
        let imageUrl = lhs.imageUrl == rhs.imageUrl
        let leaderName = lhs.leaderName == rhs.leaderName
        let address = lhs.address == rhs.address
        let phone = lhs.phone == rhs.phone
        let email = lhs.email == rhs.email
        
        return imageUrl && leaderName && address && phone && email
    }
    
}
