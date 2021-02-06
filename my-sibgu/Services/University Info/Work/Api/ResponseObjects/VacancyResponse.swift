//
//  VacancyResponse.swift
//  my-sibgu
//
//  Created by art-off on 06.02.2021.
//

import Foundation

class VacancyResponse: Decodable {
    
    let id: Int
    let name: String
    let info: [String: String]
    
}

extension VacancyResponse {
    
    func converteToDomain() -> Vacancy {
        return Vacancy(id: id, name: name, info: info)
    }
    
}
