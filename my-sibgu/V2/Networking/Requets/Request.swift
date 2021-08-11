//
//  Request.swift
//  my-sibgu
//
//  Created by Artem Rylov on 09.08.2021.
//

import Foundation

// MARK: - Models
enum RequestModel {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Version: String {
        case v1
        case v2
    }
}

// MARK: - Protocol
protocol Request {

    associatedtype Response: Decodable
    
    var method: RequestModel.Method { get }
    
    var queryParams: [String: String]? { get }
    var jsonParams: [String: Any]? { get }
    
    // It's for extension like RequestWithParams
    var finalQueryParams: [String: String]? { get }
    var finalJsonParams: [String: Any]? { get }
    
    // All to Path
    var baseUrlString: String { get }
    var apiVersion: RequestModel.Version { get }
    var path: String { get }
}

// MARK: - Defalut
extension Request {
    
    var baseUrlString: String { "https://mysibsau.ru" }
    var apiVersion: RequestModel.Version { .v2 }
    
    // this is necessary in order not to implement properties
    // where it is no needed
    var queryParams: [String: String]? { nil }
    var jsonParams: [String: Any]? { nil }
    
    var finalQueryParams: [String: String]? { queryParams }
    var finalJsonParams: [String: Any]? { jsonParams }
}

// MARK: - FinalUrlRequest
extension Request {
    
    var finalUrlRequest: URLRequest {
        let finalUrlString = baseUrlString
            + "/" + apiVersion.rawValue
            + (path.starts(with: "/") ? "" : "/") + path
        
        // set query params
        var urlComponents = URLComponents(string: finalUrlString)!
        finalQueryParams.let { params in
            urlComponents.queryItems = params.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        
        // set json params
        finalJsonParams.let { params in
            guard let jsonData = try? JSONSerialization.data(withJSONObject: params) else {
                print("Can't serialization jsonDictionary to data:", params)
                return
            }
            urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
        }
        
        // set method
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}


struct SomeRequest: Request {
    
    typealias Response = String
    
    var method: RequestModel.Method { .get }
    var path: String { "" }
}
