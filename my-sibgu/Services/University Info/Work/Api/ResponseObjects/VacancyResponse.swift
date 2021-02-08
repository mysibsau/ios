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
    
    let company: String?
    let requirements: String?
    let duties: String?
    let conditions: String?
    let schedule: String?
    let salary: String?
    let address: String?
    let addInfo: String?
    let contacts: String?
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case company
        case requirements
        case duties
        case conditions
        case schedule
        case salary
        case address
        case addInfo = "add_info"
        case contacts
        case date = "publication_date"
    }
    
}

extension VacancyResponse {
    
    func converteToDomain() -> Vacancy {
        return Vacancy(
            id: id,
            name: name,
            company: company,
            requirements: requirements,
            duties: duties,
            conditions: conditions,
            schedule: schedule,
            salary: salary,
            address: address,
            addInfo: addInfo,
            contacts: contacts,
            publicationDate: date
        )
    }
    
}
