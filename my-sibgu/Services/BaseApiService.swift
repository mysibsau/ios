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
    func load<T: Decodable>(_ type: T.Type, url: URLRequest, completion: @escaping (T?) -> Void) {
        var downloadedObjects: T?
        
        let completionOperation = BlockOperation {
            completion(downloadedObjects)
        }
        
        let downloadingOperation = DownloadOperation(session: session, urlRequest: url) { data, response, error in
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
    
    func sendPost(request: URLRequest, completion: @escaping (_ isDone: Bool) -> Void) {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false)
                return
            }
            
            print(response)
            
            print(try? JSONSerialization.jsonObject(with: data ?? Data()))

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                completion(false)
                return
            }
            
            completion(true)
        }
        
        task.resume()
    }
    
}
