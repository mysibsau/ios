//
//  SurveyResponse.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import Foundation

class SurveyResponse: Decodable {
    
    let name: String
    let questions: [QuestionResponse]
    
}

class QuestionResponse: Decodable {
    
    let id: Int
    let name: String
    let necessarily: Bool
    let answers: [AnswerResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case necessarily
        case answers = "responses"
    }
    
}

class AnswerResponse: Decodable {
    
    let id: Int
    let text: String
    
}

extension SurveyResponse {
    
    func converteToDomain() -> Survey {
        return Survey(
            name: self.name,
            questions: self.questions.map { $0.converteToDomain() }
        )
    }
    
}

extension QuestionResponse {
    
    func converteToDomain() -> Question {
        return Question(
            id: self.id,
            name: self.name,
            necessarily: self.necessarily,
            answers: self.answers.map { $0.converteToDomain() }
        )
    }
    
}

extension AnswerResponse {
    
    func converteToDomain() -> Answer {
        return Answer(id: self.id, text: self.text)
    }
    
}
