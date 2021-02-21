//
//  ApiCafeteriaService.swift
//  my-sibgu
//
//  Created by art-off on 21.02.2021.
//

import Foundation

class ApiCafeteriaService {
    
    private let baseApiService = BaseApiService()
    
    
    func loadCafeterias(completion: @escaping (_ faq: [CafeteriaResponse]?) -> Void) {
        baseApiService.load([CafeteriaResponse].self, url: ApiCafeteria.allCafeterias(), completion: completion)
    }
    
}
