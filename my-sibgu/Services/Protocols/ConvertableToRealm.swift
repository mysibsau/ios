//
//  ConvertableToRealm.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation
import RealmSwift

protocol ConvertableToRealm {
    
    associatedtype RealmProtocol: Object
    
    func converteToRealm() -> RealmProtocol
    
}
