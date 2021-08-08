//
//  RArtAssociated.swift
//  my-sibgu
//
//  Created by Artem Rylov on 07.08.2021.
//

import Foundation
import RealmSwift

class RArtAssociated: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var logo = ""
    @objc dynamic var name = ""
    @objc dynamic var description1 = ""
    @objc dynamic var contacts = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
