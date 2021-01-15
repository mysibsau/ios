//
//  RGroup+newObject.swift
//  my-sibgu
//
//  Created by art-off on 12.11.2020.
//

import Foundation
import RealmSwift

extension RGroup {
    
    func newObject() -> RGroup {
        let newGroup = RGroup()
        newGroup.id = id
        newGroup.name = name
//        newGroup.email = email
        // newGroup.leaderName = leaderName
        // newGroup.leaderEmail = leaderEmail
        // newGroup.leaderPhone = leaderPhone
        
        return newGroup
    }
    
}

