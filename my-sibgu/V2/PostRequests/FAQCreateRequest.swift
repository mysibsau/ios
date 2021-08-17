//
//  FAQCreateRequest.swift
//  my-sibgu
//
//  Created by Artem Rylov on 17.08.2021.
//

import Foundation

struct FAQCreateRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    
    // String as placeholder
    typealias Response = String
    
    var apiVersion: RequestModel.Version { .v3 }
    var path: String { "/support/faq/" }
    var method: RequestModel.Method { .post }
    
    var jsonParams: [String : Any]? {
        ["question": question,
         "theme": theme,
         "is_public": isPublic]
    }
    
    let question: String
    let theme: String?
    let isPublic: Bool?
}
