//
//  SupportService.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import Foundation

class SupportService {
    
    func aksQuestion(question: String, completion: @escaping (Bool) -> Void) {
        ApiSupportService().askQuesiont(question: question, completion: completion)
    }
    
}
