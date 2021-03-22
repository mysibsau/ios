//
//  PerformanceConcertResponse.swift
//  my-sibgu
//
//  Created by art-off on 22.03.2021.
//

import Foundation

class PerformanceConcertResponse: Decodable {
    let id: Int
    let date: String
    let time: String
    let hall: String
    let minPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case time
        case hall
        case minPrice = "min_price"
    }
}

extension PerformanceConcertResponse {
    func converteToDomain() -> PerformanceConcert {
        return PerformanceConcert(
            id: id,
            date: date,
            time: time,
            hall: hall,
            minPrice: minPrice
        )
    }
}
