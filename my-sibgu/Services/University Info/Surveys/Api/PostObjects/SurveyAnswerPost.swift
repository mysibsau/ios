//
//  SurveyAnswerPost.swift
//  my-sibgu
//
//  Created by art-off on 18.01.2021.
//

import Foundation

class SurveyAnswersPost: Encodable {
    
    let uuid: String
    let questions: [AnswerPost]
    
    init(uuid: String, question: [AnswerPost]) {
        self.uuid = uuid
        self.questions = question
    }
    
}

enum AnswerPost: Encodable {
    
    case text(TextAnswerPost)
    case select(SelectAnswerPost)
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .text(let textAnswer):
            try container.encode(textAnswer)
        case .select(let selectAnswer):
            try container.encode(selectAnswer)
        }
    }
    
}

class TextAnswerPost: Encodable {
    
    let id: Int
    let text: String
    
    init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
    
}

class SelectAnswerPost: Encodable {
    
    let id: Int
    let answers: [Int]
    
    init(id: Int, answers: [Int]) {
        self.id = id
        self.answers = answers
    }
    
}


