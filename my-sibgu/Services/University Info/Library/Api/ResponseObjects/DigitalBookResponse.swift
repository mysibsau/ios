//
//  DigitalBookResponse.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import Foundation

class DigitalBookResponse: Decodable {
    
    let name: String
    let author: String
    let url: String
    
}

extension DigitalBookResponse {
    func converteToDomain() -> DigitalBook {
        return DigitalBook(name: name, author: author, url: URL(string: url))
    }
}
