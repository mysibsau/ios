//
//  ApiInformingService.swift
//  my-sibgu
//
//  Created by art-off on 09.01.2021.
//

import Foundation

class ApiInformingService {
    
    private let baseApiService = BaseApiService()
    
    
    func loadEvents(completion: @escaping (_ events: [EventResponse]?) -> Void) {
        load([EventResponse].self, url: ApiInforming.allEvents(), completion: completion)
    }
    
    func loadNews(completion: @escaping (_ events: [NewsResponse]?) -> Void) {
        load([NewsResponse].self, url: ApiInforming.allNews(), completion: completion)
    }
    
    
    private func load<T: Decodable>(_ type: T.Type, url: URL, completion: @escaping (T?) -> Void) {
        var downloadedObjects: T?
        
        let completionOperation = BlockOperation {
            completion(downloadedObjects)
        }
        
        let downloadingOperation = DownloadOperation(session: baseApiService.session, url: url) { data, response, error in
            guard let response = ResponseHandler.handleResponse(T.self, data, response, error) else {
                completion(nil)
                self.baseApiService.cancelAllDownloading()
                return
            }
            
            downloadedObjects = response
        }
        
        completionOperation.addDependency(downloadingOperation)
        
        baseApiService.downloadingQueue.addOperation(downloadingOperation)
        baseApiService.downloadingQueue.addOperation(completionOperation)
    }
    
}
