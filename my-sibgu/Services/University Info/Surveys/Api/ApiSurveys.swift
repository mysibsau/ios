//
//  ApiSurveys.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import Foundation

class ApiSurveys {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func allSurveys() -> URL {
        let uuid = ApiUniversityInfo.currDeviceStringUuid
        return URL(string: "\(address)/surveys/all/?uuid=\(uuid)")!
    }
    
    static func survey(withId id: Int) -> URL {
        let uuid = ApiUniversityInfo.currDeviceStringUuid
        return URL(string: "\(address)/surveys/\(id)/?uuid=\(uuid)")!
    }
    
}
