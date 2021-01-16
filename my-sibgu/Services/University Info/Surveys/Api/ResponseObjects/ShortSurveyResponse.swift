//
//  ShortSurveyResponse.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import Foundation

class ShortSurveyResponse: Decodable {
    
    let id: Int
    let name: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
}

extension ShortSurveyResponse {
    
    func converteToDomain() -> ShortSurvey {
        return ShortSurvey(id: self.id, name: self.name)
    }
    
}
