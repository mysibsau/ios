//
//  ApiSurveys.swift
//  my-sibgu
//
//  Created by art-off on 16.01.2021.
//

import Foundation

class ApiSurveys {
    
    static let address = ApiUniversityInfo.addressByVersion
    
    static func allSurveys() -> URLRequest {
        let uuid = ApiUniversityInfo.currDeviceStringUuid
        let urlRequest = URLRequest(url: URL(string: "\(address)/surveys/all/?uuid=\(uuid)")!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
    }
    
    static func survey(withId id: Int) -> URLRequest {
        let uuid = ApiUniversityInfo.currDeviceStringUuid
        let urlRequest = URLRequest(url: URL(string: "\(address)/surveys/\(id)/?uuid=\(uuid)")!, cachePolicy: .reloadIgnoringLocalCacheData)
        return urlRequest
    }
    
    static func post(surveyId: Int, answers: [AnswerPost]) -> URLRequest {
        let uuid = ApiUniversityInfo.currDeviceStringUuid
        let url = URL(string: "\(address)/surveys/\(surveyId)/set_answer")!
        
        let surveyAnswerPost = SurveyAnswersPost(uuid: uuid, question: answers)
        let jsonData = try! JSONEncoder().encode(surveyAnswerPost)
        
        let request = ApiUniversityInfo.postRequest(with: url, andJsonData: jsonData)
        return request
    }
    
}
