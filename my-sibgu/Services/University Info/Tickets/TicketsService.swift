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
    
}
