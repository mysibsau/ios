//
//  Timetable.swift
//  my-sibgu
//
//  Created by art-off on 27.01.2021.
//

import Foundation

struct GroupTimetable {
//    let type: EntitiesType
    let groupName: String
    let groupId: Int
    var weeks: [Week]
}

struct ProfessorTimetable {
    let professorName: String
    let professorId: Int
    var weeks: [Week]
}

struct PlaceTimetable {
    let placeName: String
    let placeId: Int
    var weeks: [Week]
}


struct Week {
    var days: [Day?]
}


struct Day {
    var lessons: [Lesson]
}


struct Lesson {
    let time: String
    let subgroups: [Subgroup]
}


struct Subgroup {
    
    let number: Int
    let subject: String
    let type: SubgroupType
    
    let group: String
    let professor: String
    let place: String
    
    let groupId: Int
    let professorId: Int
    let placeId: Int
    
}
