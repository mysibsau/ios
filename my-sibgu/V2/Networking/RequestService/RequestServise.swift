//
//  RequestServise.swift
//  my-sibgu
//
//  Created by Artem Rylov on 10.08.2021.
//

import Foundation

class RequestServise {
    
    static let shared = RequestServise()
    
    // MARK: - Privates properties
    private let downloadingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // MARK: - Прекращение всех загрузок
    func cancelAllDownloading() {
        downloadingQueue.cancelAllOperations()
    }
    
    // MARK: - Функция загрузки
    func perform<T: Request>(_ request: T, completion: @escaping (T.Response?) -> Void) {
        var downloadedObject: T.Response?
        
        let completionOperation = BlockOperation {
            completion(downloadedObject)
        }
        
        let downloadingOperation = DownloadOperation(session: session, urlRequest: request.finalUrlRequest) { data, response, error in
            guard let response = Self.handleResponse(T.Response.self, data, response, error) else {
                completion(nil)
                self.cancelAllDownloading()
                return
            }
            
            downloadedObject = response
        }
        
        completionOperation.addDependency(downloadingOperation)
        
        downloadingQueue.addOperation(downloadingOperation)
        downloadingQueue.addOperation(completionOperation)
    }
    
    private static func handleResponse<T: Decodable>(_ type: T.Type, _ data: Data?, _ response: URLResponse?, _ error: Error?) -> T? {
        guard
            error == nil,
            let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode),
            let data = data
        else {
            print("Can't handle response, error: \(String(describing: error)), response: \(String(describing: response)), data: \(String(describing: data))")
            return nil
        }
        
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return response
        } catch let jsonError {
            print(jsonError)
            return nil
        }
    }
}
