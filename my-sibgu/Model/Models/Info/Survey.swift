//
//  Survey.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import Foundation

struct Survey {
    
    let name: String
    let questions: [Question]
    
}

struct Question {
    
    let id: Int
    let name: String
    let necessarily: Bool
    let answers: [Answer]
    
}

struct Answer {
    
    let id: Int
    let text: String
    
}
