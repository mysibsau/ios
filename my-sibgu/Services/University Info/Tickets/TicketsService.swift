//
//  TicketsService.swift
//  my-sibgu
//
//  Created by art-off on 22.03.2021.
//

import Foundation

class TicketsService {
    
    func getPerformances(completion: @escaping ([Performance]?) -> Void) {
        ApiTicketsService().loadPerformances { performancesResponse in
            completion(performancesResponse?.map { $0.converteToDomain() })
        }
    }
    
    func getConcert(by performanceId: Int, completion: @escaping ([PerformanceConcert]?) -> Void) {
        ApiTicketsService().loadConcerts(by: performanceId) { concertsResponse in
            completion(concertsResponse?.map { $0.converteToDomain() })
        }
    }
    
}
