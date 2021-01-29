//
//  RTimetable.swift
//  my-sibgu
//
//  Created by art-off on 27.01.2021.
//
//

import Foundation
import RealmSwift

class RGroupTimetable: Object {

    @objc dynamic var objectId = 0
    let weeks = List<RWeek>()

    override class func primaryKey() -> String? {
        return "objectId"
    }
    
}

class RProfessorTimetable: Object {

    @objc dynamic var objectId = 0
    let weeks = List<RWeek>()

    override class func primaryKey() -> String? {
        return "objectId"
    }
    
}

class RPlaceTimetable: Object {

    @objc dynamic var objectId = 0
    let weeks = List<RWeek>()

    override class func primaryKey() -> String? {
        return "objectId"
    }
    
}


class RWeek: Object {
    
    @objc dynamic var number = 0
    let days = List<RDay>()
    
}

class RDay: Object {
    
    @objc dynamic var number = 0
    var lessons = List<RLesson>()
    
}

class RLesson: Object {
    
    @objc dynamic var time = ""
    var subgroups = List<RSubgroup>()
    
}

class RSubgroup: Object {
    
    @objc dynamic var number = 0
    @objc dynamic var subject = ""
    @objc dynamic var type = 0
    
    @objc dynamic var group = ""
    @objc dynamic var professor = ""
    @objc dynamic var place = ""
    
    @objc dynamic var groupId = 0
    @objc dynamic var professorId = 0
    @objc dynamic var placeId = 0
    
}
