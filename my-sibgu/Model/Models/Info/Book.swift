//
//  Book.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import Foundation

struct DigitalBook: Codable {
    
    let name: String
    let author: String
    let url: URL?
    
}

struct PhysicalBook: Codable {
    
    let name: String
    let author: String
    let place: String
    let count: Int
    
}
