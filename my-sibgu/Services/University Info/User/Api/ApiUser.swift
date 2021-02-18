//
//  ApiAuth.swift
//  my-sibgu
//
//  Created by art-off on 10.02.2021.
//

import Foundation

struct ApiUser {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func authUser(number: String, password: String) -> URLRequest {
        let parameters = [
            "username": number,
            "password": password,
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        var request = ApiUniversityInfo.postRequest(with: URL(string: "\(address)/user/auth/")!, andJsonData: jsonData)
        request.httpMethod = "POST"
        return request
    }

}
