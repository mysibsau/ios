//
//  FAQResponse.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import Foundation

// MARK: - Request
class FAQListRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {

    typealias Response = [FAQResponse]

    var apiVersion: RequestModel.Version { .v3 }
    var path: String { "/support/faq/" }
}

struct FAQMyListRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    
    typealias Response = [FAQResponse]
    
    var apiVersion: RequestModel.Version { .v3 }
    var path: String { "/support/faq/my/" }
}

// MARK: - Model
struct FAQResponse: Decodable, Equatable {
    
    let id: Int
    let question: String
    let answer: String
    let views: Int
    let createDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id,
             question,
             answer,
             views,
             createDate = "create_data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        question = try container.decode(String.self, forKey: .question)
        answer = try container.decode(String.self, forKey: .answer)
        views = try container.decode(Int.self, forKey: .views)
        let stringDate = try container.decode(String.self, forKey: .createDate)
        createDate = Self.dateFormatter.date(from: stringDate)!
    }
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        return df
    }()
}
