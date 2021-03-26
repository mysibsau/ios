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
    
    func loadConcerts(by performanceId: Int, completion: @escaping (_ concerts: [PerformanceConcertResponse]?) -> Void) {
        baseApiService.load([PerformanceConcertResponse].self, url: ApiTickets.concerts(by: performanceId), completion: completion)
    }
    
    func loadConcert(id: Int, completion: @escaping (_ concert: [[RoomItemResponse?]]?) -> Void) {
        baseApiService.load([[RoomItemResponse?]].self, url: ApiTickets.concert(id: id), completion: completion)
    }
    
}
