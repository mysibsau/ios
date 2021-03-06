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

extension RProfessor {
    
    func newObject() -> RProfessor {
        let newProfessor = RProfessor()
        newProfessor.id = id
        newProfessor.name = name
        newProfessor.idPallada = idPallada
        return newProfessor
    }
    
}

extension RPlace {
    
    func newObject() -> RPlace {
        let newPlace = RPlace()
        newPlace.id = id
        newPlace.name = name
        newPlace.address = address
        return newPlace
    }
    
}
