//
//  GroupTimetableResponse.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class GroupTimetableResponse: Decodable {
    
    let groupName: String
    var evenWeek: [GroupDayResponse]
    var oddWeek: [GroupDayResponse]
//    let groupHash: String
    let meta: MetaResponse
    
    
    enum CodingKeys: String, CodingKey {
        case groupName = "object"
        case evenWeek = "even_week"
        case oddWeek = "odd_week"
//        case groupHash = "hash"
        case meta
    }
    
}

class GroupDayResponse: Decodable {
    
    let number: Int
    var lessons: [GroupLessonResponse]

    enum CodingKeys: String, CodingKey {
        case number = "day"
        case lessons
    }
    
}

class GroupLessonResponse: Decodable {
    
    let time: String
    var subgroups: [SubgroupResponse]
    
    enum CodingKeys: String, CodingKey {
        case time
        case subgroups
    }
    
}
//
//class GroupSubgroupResponse: Decodable {
//
//    let number: Int
//    let subject: String
//    let type: Int
//    let place: String
//    let professor: String
//
//    enum CodingKeys: String, CodingKey {
//        case number = "num"
//        case subject = "name"
//        case type
//        case place
//        case professor = "teacher"
//    }
//
//}
