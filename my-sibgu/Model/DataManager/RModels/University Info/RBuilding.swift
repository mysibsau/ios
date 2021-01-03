//
//  RBuilding.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//
//

import Foundation
import RealmSwift

class RBuilding: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var address = ""
    @objc dynamic var coast = 0
    @objc dynamic var urlTo2gis = ""
    
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
}
