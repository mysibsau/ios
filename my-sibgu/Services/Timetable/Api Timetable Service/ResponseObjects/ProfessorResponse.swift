//
//  ProfessorResponse.swift
//  my-sibgu
//
//  Created by art-off on 27.01.2021.
//

import Foundation

class ProfessorResponse: Decodable {
    
    let id: Int
    let name: String
    let idPallada: Int
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case idPallada = "id_pallada"
    }
    
}
