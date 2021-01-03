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
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    
    // MARK: - Прекращение всех загрузок
    func cancelAllDownloading() {
        downloadingQueue.cancelAllOperations()
    }
    
}
