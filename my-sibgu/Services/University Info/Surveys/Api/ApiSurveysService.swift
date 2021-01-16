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
    
}
