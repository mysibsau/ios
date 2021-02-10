//
//  RUser.swift
//  my-sibgu
//
//  Created by art-off on 10.02.2021.
//

import RealmSwift

class RUser: Object {
    
    
    @objc dynamic var token = ""
    @objc dynamic var fio = ""
    @objc dynamic var averageRating: Double = 0
    @objc dynamic var group = ""
    @objc dynamic var zachotka = ""
    
    
    override class func primaryKey() -> String? {
        return "zachotka"
    }
    
}
