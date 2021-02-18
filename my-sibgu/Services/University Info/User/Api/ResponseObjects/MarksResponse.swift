//
//  MarksResponse.swift
//  my-sibgu
//
//  Created by art-off on 18.02.2021.
//

import Foundation

class MarksResponse: Decodable {
    
    let term: String
    let items: [TermMarksResponse]
    
}

class TermMarksResponse: Decodable {
    
    let name: String
    let mark: String
    let type: String
    
}

extension MarksResponse {
    
    func converteToDomain() -> Marks {
        return Marks(
            term: term,
            items: items.map { $0.converteToDomain() }
        )
    }
    
}

extension TermMarksResponse {
    
    func converteToDomain() -> TermMarks {
        return TermMarks(
            name: name,
            mark: mark,
            type: type
        )
    }
    
}
