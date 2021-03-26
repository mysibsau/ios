//
//  PerformanceResponse.swift
//  my-sibgu
//
//  Created by art-off on 22.03.2021.
//

import Foundation

class PerformanceResponse: Decodable {
    
    let id: Int
    let name: String
    let theatre: String
    let about: String
    let logo: String
    
}

extension PerformanceResponse {
    func converteToDomain() -> Performance {
        return Performance(
            id: id,
            name: name,
            theatre: theatre,
            about: about,
            logoUrl: ApiUniversityInfo.download(with: logo)
        )
    }
}
