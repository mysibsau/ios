//
//  RSportClub.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import RealmSwift

class RSportClub: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var fio: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var dates: String = ""
    
    @objc dynamic var logoUrl: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
