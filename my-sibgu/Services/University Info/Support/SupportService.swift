//
//  SupportService.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import Foundation

class SupportService {
    
    func getAllFaq(completion: @escaping ([FAQ]?) -> Void) {
        ApiSupportService().loadFaq { faq in
            guard let faq = faq else {
                completion(nil)
                return
            }
            
            completion(faq.map { $0.converteToDomain() })
        }
    }
    
    func viewFaq(with id: Int, completion: @escaping (Bool?) -> Void) {
        ApiSupportService().viewFaq(withId: id, completion: completion)
    }
    
    func aksQuestion(question: String, completion: @escaping (Bool) -> Void) {
        ApiSupportService().askQuesiont(question: question, completion: completion)
    }
    
}
