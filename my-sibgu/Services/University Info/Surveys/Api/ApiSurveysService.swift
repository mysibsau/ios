//
//  ApiSurveysService.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import Foundation

class ApiSurveysService {
    
    private let baseApiService = BaseApiService()
    
    func loadSurveys(completion: @escaping (_ surveys: [ShortSurveyResponse]?) -> Void) {
        baseApiService.load([ShortSurveyResponse].self, url: ApiSurveys.allSurveys(), completion: completion)
    }
    
    func loadSurvey(with id: Int, completion: @escaping (_ events: SurveyResponse?) -> Void) {
        baseApiService.load(SurveyResponse.self, url: ApiSurveys.survey(withId: id), completion: completion)
    }
    
    func post(surveyId: Int, answers: [AnswerPost], completion: @escaping (Bool) -> Void) {
        // Избавляемся от ответов, в которых нет вопросов (сервак падает, если отсылать такое)
        var answertWithoutEmpty: [AnswerPost] = []
        for answer in answers {
            switch answer {
            case .select(let selectAnswer):
                if !selectAnswer.answers.isEmpty {
                    answertWithoutEmpty.append(.select(selectAnswer))
                }
            case .text(let textAnswer):
                answertWithoutEmpty.append(.text(textAnswer))
            }
        }
        
        let request = ApiSurveys.post(surveyId: surveyId, answers: answertWithoutEmpty)
        
        let task = baseApiService.session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false)
                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                completion(false)
                return
            }
            
            completion(true)
        }
        
        task.resume()
    }
    
}
