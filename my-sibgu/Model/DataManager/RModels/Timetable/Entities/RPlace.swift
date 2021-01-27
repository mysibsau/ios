//
//  RPlace.swift
//  my-sibgu
//
//  Created by art-off on 27.01.2021.
//

import Foundation
import RealmSwift

class RPlace: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
