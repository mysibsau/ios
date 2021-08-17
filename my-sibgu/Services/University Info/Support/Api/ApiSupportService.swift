//
//  ApiSupportService.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import Foundation

class ApiSupportService {
    
    private let baseApiService = BaseApiService()
    
    func askQuesiont(question: String, completion: @escaping (Bool) -> Void) {
        let request = ApiSupport.askQuestion(question: question)
        
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
