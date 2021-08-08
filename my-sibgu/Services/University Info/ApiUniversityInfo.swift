//
//  ApiUniversityInfo.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

struct ApiUniversityInfo {
    
    static let address = "https://mysibsau.ru"
    
    static let addressByVersion = "\(address)/v2"
    
    static func download(with postfix: String) -> URL {
        let url = URL(string: "\(address)\(postfix)")!
                        //.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        return url
    }
    
    static var currDeviceStringUuid: String {
        let uuidForApi = UserDefaultsConfig.uuidForApi
        
        // Если уже генерировал - отдам, иначе сгенерирую и отдам
        if let u = uuidForApi {
            return u
        } else {
            let newUuid = UUID().uuidString
            UserDefaultsConfig.uuidForApi = newUuid
            return newUuid
        }
    }
    
}

// MARK: - Multipart Request
extension ApiUniversityInfo {
    
    static func multipartRequest(withUrl url: URL, parameters: [String: String]) -> URLRequest {
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBodyForMultipart(withParameters: parameters, boundary: boundary)
        
        return request
    }
    
    private static func httpBodyForMultipart(withParameters parameters: [String: String], boundary: String) -> Data {
        var httpBody = Data()
        for (key, value) in parameters {
            httpBody.append(Data(convertFormField(named: key, value: value, using: boundary).utf8))
        }
        httpBody.append(Data("--\(boundary)--".utf8))
        
        return httpBody
    }
    
    private static func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }
    
}

// MARK: - Post Request
extension ApiUniversityInfo {
    
    static func postRequest(with url: URL, json: [String: Any]) -> URLRequest {
        postRequest(with: url,
                    andJsonData: try! JSONSerialization.data(withJSONObject: json,
                                                             options: .prettyPrinted))
    }
    
    static func postRequest(with url: URL, andJsonData jsonData: Data) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return request
    }
    
}
