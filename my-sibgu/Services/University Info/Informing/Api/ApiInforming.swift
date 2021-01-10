//
//  ApiInformint.swift
//  my-sibgu
//
//  Created by art-off on 09.01.2021.
//

import Foundation

class ApiInforming {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func allEvents() -> URL {
        let uuid = ApiUniversityInfo.currDeviceStringUuid
        return URL(string: "\(address)/informing/all_events/?uuid=\(uuid)")!
    }
    
}
