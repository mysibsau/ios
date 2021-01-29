//
//  BaseApiService.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class BaseApiService {
    
    // MARK: - Privates properties
    let downloadingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    
    // MARK: - Прекращение всех загрузок
    func cancelAllDownloading() {
        downloadingQueue.cancelAllOperations()
    }
    
    // MARK: - Функция загрузки
    func load<T: Decodable>(_ type: T.Type, url: URL, completion: @escaping (T?) -> Void) {
        var downloadedObjects: T?
        
        let completionOperation = BlockOperation {
            completion(downloadedObjects)
        }
        
        let downloadingOperation = DownloadOperation(session: session, url: url) { data, response, error in
            guard let response = ResponseHandler.handleResponse(T.self, data, response, error) else {
                completion(nil)
                self.cancelAllDownloading()
                return
            }
            
            downloadedObjects = response
        }
        
        completionOperation.addDependency(downloadingOperation)
        
        downloadingQueue.addOperation(downloadingOperation)
        downloadingQueue.addOperation(completionOperation)
    }
    
}
