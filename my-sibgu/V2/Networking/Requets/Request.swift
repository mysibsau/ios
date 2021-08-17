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
        case v3
    }
}

// MARK: - Protocol
protocol Request {

    associatedtype Response: Decodable
    
    var method: RequestModel.Method { get }
    
    var queryParams: [String: String]? { get }
    var jsonParams: [String: Any]? { get }
    var headerParams: [String: String]? { get }
    
    // All to Path
    var baseUrlString: String { get }
    var apiVersion: RequestModel.Version { get }
    var path: String { get }
    
    var finalQueryParams: [String: String]? { get }
    var finalJsonParams: [String: Any]? { get }
    var finalHeaderParams: [String: String]?  { get }
}

// MARK: - Defalut
extension Request {
    
    var baseUrlString: String { NetworkingConstants.mysibsauServerAddress }
    var method: RequestModel.Method { .get }
    var apiVersion: RequestModel.Version { .v2 }
    
    // this is necessary in order not to implement properties
    // where it is no needed
    var queryParams: [String: String]? { nil }
    var jsonParams: [String: Any]? { nil }
    var headerParams: [String: String]? { nil }
    
    var finalQueryParams: [String: String]? { queryParams }
    var finalJsonParams: [String: Any]? { jsonParams }
    var finalHeaderParams: [String: String]?  { headerParams }
}

// MARK: - Additional Property
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
        
        finalHeaderParams.let { params in
            params.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // set method
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
