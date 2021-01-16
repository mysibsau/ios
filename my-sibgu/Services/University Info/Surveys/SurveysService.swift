//
//  SurveysService.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import Foundation

class SurveysService {
    
    func getAllSurveys(completion: @escaping ([ShortSurvey]?) -> Void) {
        ApiSurveysService().loadSurveys { surveys in
            guard let surveys = surveys else {
                completion(nil)
                return
            }
            
            completion(surveys.map { $0.converteToDomain() })
        }
    }
    
    func getSurvey(with id: Int, completion: @escaping (Survey?) -> Void) {
        ApiSurveysService().loadSurvey(with: id) { survey in
            guard let survey = survey else {
                completion(nil)
                return
            }
            
            completion(survey.converteToDomain())
        }
    }
    
}
