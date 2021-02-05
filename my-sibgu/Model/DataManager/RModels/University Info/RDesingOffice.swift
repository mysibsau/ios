//
//  RDesingOffice.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import RealmSwift

class RDesingOffice: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var about: String = ""
    @objc dynamic var fio: String? = nil
    @objc dynamic var email: String? = nil
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
