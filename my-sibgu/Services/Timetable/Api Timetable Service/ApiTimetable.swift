//
//  ApiTimetable.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

struct ApiTimetable {
    
    static let address = "https://timetable.mysibsau.ru" // "http://185.228.233.243"
    
    // MARK: Curr Week Is Even
    static func currWeekIsEven() -> URL {
        return URL(string: "\(address)/CurrentWeekIsEven/")!
    }
    
    // MARK: - Group
    static func groups() -> URL {
        return URL(string: "\(address)/groups")!
    }
    
    static func timetable(forGroupId groupId: Int) -> URL {
        return URL(string: "\(address)/timetable/\(groupId)")!
    }
    
    static func groupsHash() -> URL {
        return URL(string: "\(address)/hash")!
    }
    
}
