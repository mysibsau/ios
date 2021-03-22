//
//  ApiTicketsService.swift
//  my-sibgu
//
//  Created by art-off on 22.03.2021.
//

import Foundation

class ApiTicketsService {
    
    private let baseApiService = BaseApiService()
    
    
    func loadPerformances(completion: @escaping (_ performances: [PerformanceResponse]?) -> Void) {
        baseApiService.load([PerformanceResponse].self, url: ApiTickets.allPerformances(), completion: completion)
    }
    
}
