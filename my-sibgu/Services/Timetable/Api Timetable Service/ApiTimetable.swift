//
//  ApiTimetable.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

struct ApiTimetable {
    
    static let address = "https://mysibsau.ru/v2/timetable" // "http://185.228.233.243"
    
    
    // MARK: - Entries
    static func groups() -> URL {
        return URL(string: "\(address)/all_groups/")!
    }
    
    static func professors() -> URL {
        return URL(string: "\(address)/all_teachers/")!
    }
    
    static func places() -> URL {
        return URL(string: "\(address)/all_places/")!
    }
    
    
    // MARK: - Timetables
    static func timetable(forGroupId groupId: Int) -> URLRequest {
        return URLRequest(url: URL(string: "\(address)/group/\(groupId)")!, cachePolicy: .reloadIgnoringLocalCacheData)
    }
    
    static func timetable(forProfessorId professorId: Int) -> URLRequest {
        return URLRequest(url: URL(string: "\(address)/teacher/\(professorId)")!, cachePolicy: .reloadIgnoringLocalCacheData)
    }
    
    static func timetable(forPlaceId placeId: Int) -> URLRequest {
        return URLRequest(url: URL(string: "\(address)/place/\(placeId)")!, cachePolicy: .reloadIgnoringLocalCacheData)
    }
    
    
    // MARK: - Hash
    static func groupsHash() -> URL {
        return URL(string: "\(address)/hash/groups/")!
    }
    
    static func professorsHash() -> URL {
        return URL(string: "\(address)/hash/teachers/")!
    }
    
    static func placesHash() -> URL {
        return URL(string: "\(address)/hash/places")!
    }
    
}
