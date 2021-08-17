//
//  SupportService.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import Foundation

class SupportService {
    
    func viewFaq(with id: Int, completion: @escaping (Bool?) -> Void) {
        ApiSupportService().viewFaq(withId: id, completion: completion)
    }
    
    func aksQuestion(question: String, completion: @escaping (Bool) -> Void) {
        ApiSupportService().askQuesiont(question: question, completion: completion)
    }
    
}
