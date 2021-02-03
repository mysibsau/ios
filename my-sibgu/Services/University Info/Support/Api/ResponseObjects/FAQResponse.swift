//
//  FAQResponse.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import Foundation

class FAQResponse: Decodable {
    
    let id: Int
    let question: String
    let answer: String
    let views: Int
    
}

extension FAQResponse {
    
    func converteToDomain() -> FAQ {
        return FAQ(id: id, rank: views, question: question, answer: answer)
    }
    
}
