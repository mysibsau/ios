//
//  InformingService.swift
//  my-sibgu
//
//  Created by art-off on 10.01.2021.
//

import Foundation

class InformingService {
    
    func getEvents(completion: @escaping ([Event]?) -> Void) {
        ApiInformingService().loadEvents { events in
            guard let events = events else {
                completion(nil)
                return
            }
            
            completion(events.map { $0.converteToDomain() })
        }
    }
    
    func getNews(completion: @escaping ([News]?) -> Void) {
        ApiInformingService().loadNews { news in
            guard let news = news else {
                completion(nil)
                return
            }
            
            completion(news.map { $0.converteToDomain() })
        }
    }
    
}
