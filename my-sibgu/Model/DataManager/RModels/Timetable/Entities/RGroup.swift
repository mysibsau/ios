//
//  RGroup.swift
//  my-sibgu
//
//  Created by art-off on 12.11.2020.
//
//

import Foundation
import RealmSwift

class RGroup: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
//    @objc dynamic var email: String? = nil
    // информации о старосте пока не будет (конфиденциальность бла бла)
    // @objc dynamic var leaderName: String? = nil
    // @objc dynamic var leaderEmail: String? = nil
    // @objc dynamic var leaderPhone: String? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
