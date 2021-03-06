//
//  DownloadOperation.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class DownloadOperation: Operation {
    
    private var task: URLSessionDataTask?
    private let session: URLSession
    private let urlRequest: URLRequest
    private let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    
    // MARK: - State
    enum OperationState: Int {
        case ready
        case executing
        case finished
    }
    
    // default state is ready (when the operation is created)
    private var state: OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    
    // MARK: - Initialization
    init(session: URLSession, url: URL, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.session = session
        self.urlRequest = URLRequest(url: url)
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    init(session: URLSession, urlRequest: URLRequest, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.session = session
        self.urlRequest = urlRequest
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    
    // MARK: - Overrides Methods
    override func start() {
        /*
         if the operation or queue got cancelled even
         before the operation has started, set the
         operation state to finished and return
         */
        if (self.isCancelled) {
            state = .finished
            return
        }
        
        task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            self?.completionHandler?(data, response, error)
            self?.state = .finished
        }
        
        // set the state to executing
        state = .executing
        
        print("downloading \(self.task?.originalRequest?.url?.absoluteString ?? "")")
        
        // start the downloading
        self.task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        
        // cancel the downloading
        self.task?.cancel()
    }
    
}
