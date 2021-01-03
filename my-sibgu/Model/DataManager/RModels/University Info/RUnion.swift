//
//  RUnion.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation
import RealmSwift

class RUnion: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var shortName: String? = nil
    @objc dynamic var leaderRank: String? = nil
    @objc dynamic var leaderName = ""
    @objc dynamic var address = ""
    @objc dynamic var phone = ""
    @objc dynamic var groupVkUrl = ""
    @objc dynamic var leaderPageVkUrl: String? = nil
    @objc dynamic var about: String? = nil
    
    // ссылка на лого
    @objc dynamic var logoUrl = ""
    // ссылка на фотку председателя
    @objc dynamic var leaderPhotoUrl = ""
    
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
}
