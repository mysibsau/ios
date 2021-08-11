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
    
    // MARK: - Функции загрузки
    // Ниже функции для разного кол-ва аргументов
    
    func perform<R1: Request>(_ request1: R1,
                              completion: @escaping (R1.Response?) -> Void) {
        _perform(request1,
                 nil as R1?, nil as R1?, nil as R1?, nil as R1?, nil as R1?) { r1, _,_,_,_, _ in
            completion(r1)
        }
    }
    
    func perform<R1: Request, R2: Request>(_ request1: R1, _ request2: R2,
                                           completion: @escaping (R1.Response?, R2.Response?) -> Void) {
        _perform(request1, request2,
                 nil as R1?, nil as R1?, nil as R1?, nil as R1?) { r1, r2, _,_,_,_ in
            completion(r1, r2)
        }
    }
    
    func perform<R1: Request,
                 R2: Request,
                 R3: Request>(_ request1: R1, _ request2: R2, _ request3: R3,
                              completion: @escaping (R1.Response?, R2.Response?, R3.Response?) -> Void) {
        _perform(request1, request2, request3,
                 nil as R1?, nil as R1?, nil as R1?) { r1, r2, r3 ,_,_,_ in
            completion(r1, r2, r3)
        }
    }
}

// MARK: - Private methods for loading
extension RequestServise {
    
    private func _perform<R1: Request, R2: Request, R3: Request,
                          R4: Request, R5: Request, R6: Request>(
        _ request1: R1?, _ request2: R2?, _ request3: R3?,
        _ request4: R4?, _ request5: R5?, _ request6: R6?,
        completion: @escaping (R1.Response?,
                               R2.Response?,
                               R3.Response?,
                               R4.Response?,
                               R5.Response?,
                               R6.Response?) -> Void) {
        
        var downloadedObject1: R1.Response?
        var downloadedObject2: R2.Response?
        var downloadedObject3: R3.Response?
        var downloadedObject4: R4.Response?
        var downloadedObject5: R5.Response?
        var downloadedObject6: R6.Response?
        
        let completionOperation = BlockOperation {
            completion(downloadedObject1, downloadedObject2, downloadedObject3,
                       downloadedObject4, downloadedObject5, downloadedObject6)
        }
        
        request1.let {
            _addDownloadOperation(request: $0, completionOperation: completionOperation, completion: {
                downloadedObject1 = $0
            })
        }
        request2.let {
            _addDownloadOperation(request: $0, completionOperation: completionOperation, completion: {
                downloadedObject2 = $0
            })
        }
        request3.let {
            _addDownloadOperation(request: $0, completionOperation: completionOperation, completion: {
                downloadedObject3 = $0
            })
        }
        request4.let {
            _addDownloadOperation(request: $0, completionOperation: completionOperation, completion: {
                downloadedObject4 = $0
            })
        }
        request5.let {
            _addDownloadOperation(request: $0, completionOperation: completionOperation, completion: {
                downloadedObject5 = $0
            })
        }
        request6.let {
            _addDownloadOperation(request: $0, completionOperation: completionOperation, completion: {
                downloadedObject6 = $0
            })
        }
        
        downloadingQueue.addOperation(completionOperation)
    }
    
    private func _addDownloadOperation<R: Request>(request: R,
                                                completionOperation: BlockOperation,
                                                completion: @escaping (R.Response?) -> Void) {
        let downloadingOperation = DownloadOperation(session: session, urlRequest: request.finalUrlRequest) {  data, response, error in
            completion(Self.handleResponse(R.Response.self, data, response, error))
        }
        
        completionOperation.addDependency(downloadingOperation)
        downloadingQueue.addOperation(downloadingOperation)
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
