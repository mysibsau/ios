//
//  RInstitute.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation
import RealmSwift

class RInstitute: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var shortName = ""
    
    @objc dynamic var director: RDirector?
    @objc dynamic var soviet: RSoviet?
    
    let departments = List<RDepartment>()
    
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
}

class RDirector: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var address = ""
    @objc dynamic var phone = ""
    @objc dynamic var email = ""
    
}

class RDepartment: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var leaderName = ""
    @objc dynamic var address = ""
    @objc dynamic var phone: String? = nil
    @objc dynamic var email: String? = nil
    
}

class RSoviet: Object {
    
    @objc dynamic var imageUrl = ""
    @objc dynamic var leaderName = ""
    @objc dynamic var address = ""
    @objc dynamic var phone: String? = nil
    @objc dynamic var email: String? = nil
    
}
