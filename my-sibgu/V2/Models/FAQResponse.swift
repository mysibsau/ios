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

// MARK: - Model
struct FAQResponse: Decodable, Equatable {
    
    let id: Int
    let question: String
    let answer: String
    let views: Int
}
