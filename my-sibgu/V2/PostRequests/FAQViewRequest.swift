//
//  FAQViewRequest.swift
//  my-sibgu
//
//  Created by Artem Rylov on 17.08.2021.
//

import Foundation

struct FAQViewRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    
    // String as placeholder
    typealias Response = String
    
    var apiVersion: RequestModel.Version { .v3 }
    var path: String { "/support/faq/\(faqID)/view/" }
    var method: RequestModel.Method { .post }
    
    let faqID: Int
}
