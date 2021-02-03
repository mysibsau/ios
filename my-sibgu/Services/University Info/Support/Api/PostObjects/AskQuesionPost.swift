//
//  AskQuesionPost.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import Foundation

class AskQuesionPost: Encodable {
    
    let question: String
    
    init(question: String) {
        self.question = question
    }
    
}
