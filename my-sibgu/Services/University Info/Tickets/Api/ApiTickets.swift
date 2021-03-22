//
//  ApiTickets.swift
//  my-sibgu
//
//  Created by art-off on 22.03.2021.
//

import Foundation

class ApiTickets {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    
    static func allPerformances() -> URLRequest {
        let url = URLRequest(
            url: URL(string: "\(address)/tickets/all_perfomances/")!,
            cachePolicy: .reloadIgnoringLocalCacheData)
        return url
    }
    
    static func buy(ticketsId: [Int]) -> URLRequest {
        let token = UserService().getCurrUser()?.token ?? "0"
        
        let json = [
            "tickets": ticketsId
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        var url = ApiUniversityInfo.postRequest(
            with: URL(string: "\(address)/tickets/buy/?token=\(token)")!,
            andJsonData: jsonData
        )
        url.cachePolicy = .reloadIgnoringLocalCacheData
        return url
    }
    
    static func myTickets() -> URLRequest {
        let token = UserService().getCurrUser()?.token ?? "0"
        
        let url = URLRequest(
            url: URL(string: "\(address)/tickets/my_tickets/?token=\(token)")!,
            cachePolicy: .reloadIgnoringLocalCacheData)
        return url
    }
    
}
