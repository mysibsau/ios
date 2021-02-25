//
//  BooksResponse.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import Foundation

class BooksResponse: Decodable {
    
    let digital: [DigitalBookResponse]
    let physical: [PhysicalBookResponse]
    
}
