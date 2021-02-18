//
//  MarksResponse.swift
//  my-sibgu
//
//  Created by art-off on 18.02.2021.
//

import Foundation

class MarksResponse: Decodable {
    
    let term: Int
    let items: [TermMarksResponse]
    
}

class TermMarksResponse: Decodable {
    
    let name: String
    let mark: String
    let type: String
    
}
