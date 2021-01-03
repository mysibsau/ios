//
//  ResponseHandler.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class ResponseHandler {
    
    static func handleResponse<T: Decodable>(_ type: T.Type, _ data: Data?, _ response: URLResponse?, _ error: Error?) -> T? {
        guard
            error == nil,
            let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode),
            let data = data
        else {
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
