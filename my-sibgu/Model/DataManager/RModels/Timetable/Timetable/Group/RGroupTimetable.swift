//
//  RGroupTimetable.swift
//  my-sibgu
//
//  Created by art-off on 12.11.2020.
//
//

import Foundation
import RealmSwift

class RGroupTimetable: Object {
    
    @objc dynamic var groupId = 0
    let weeks = List<RGroupWeek>()
    
    override class func primaryKey() -> String? {
        return "groupId"
    }
    
}
