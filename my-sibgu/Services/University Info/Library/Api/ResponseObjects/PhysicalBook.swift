//
//  PhysicalBook.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import Foundation

class PhysicalBookResponse: Decodable {
    
    let name: String
    let author: String
    let place: String
    let count: Int
    
}

extension PhysicalBookResponse {
    func converteToDomain() -> PhysicalBook {
        return PhysicalBook(name: name, author: author, place: place, count: count)
    }
}
