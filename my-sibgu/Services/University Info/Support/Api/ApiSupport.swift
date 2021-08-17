//
//  ApiSupport.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import Foundation

class ApiSupport {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func askQuestion(question: String) -> URLRequest {
        let url = URL(string: "\(address)/support/ask/")!
        
        let json = AskQuesionPost(question: question)
        let jsonData = try! JSONEncoder().encode(json)
        
        let request = ApiUniversityInfo.postRequest(with: url, andJsonData: jsonData)
        return request
    }
    
    static func viewFaq(with id: Int) -> URLRequest {
        let url = URL(string: "\(address)/support/faq/\(id)/")!
        
        let request = ApiUniversityInfo.postRequest(with: url, andJsonData: Data())
        return request
    }
    
}
