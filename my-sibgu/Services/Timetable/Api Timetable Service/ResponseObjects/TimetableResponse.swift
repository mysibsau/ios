//
//  TimetableResponse.swift
//  my-sibgu
//
//  Created by art-off on 27.01.2021.
//

import Foundation


class TimetableResponse: Decodable {
    
    let objectName: String
    var evenWeek: [DayResponse]
    var oddWeek: [DayResponse]
    let meta: MetaResponse
    
    
    enum CodingKeys: String, CodingKey {
        case objectName = "object"
        case evenWeek = "even_week"
        case oddWeek = "odd_week"
        case meta
    }
    
}

class DayResponse: Decodable {
    
    let number: Int
    var lessons: [LessonRespnse]
    
    
    enum CodingKeys: String, CodingKey {
        case number = "day"
        case lessons
    }
    
}

class LessonRespnse: Decodable {
    
    let time: String
    var subgroups: [SubgroupResponse]
    
    
    enum CodingKeys: String, CodingKey {
        case time
        case subgroups
    }
    
}

class SubgroupResponse: Decodable {
    
    let number: Int
    let subject: String
    let type: Int
    
    let group: String
    let groupId: Int
    
    let place: String
    let placeId: Int
    
    let professor: String
    let professorId: Int
    
    
    enum CodingKeys: String, CodingKey {
        case number = "num"
        case subject = "name"
        case type
        case group
        case groupId = "group_id"
        case place
        case placeId = "place_id"
        case professor = "teacher"
        case professorId = "teacher_id"
    }
    
}
