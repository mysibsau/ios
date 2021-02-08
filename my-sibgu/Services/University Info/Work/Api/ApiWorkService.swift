//
//  ApiWorkService.swift
//  my-sibgu
//
//  Created by art-off on 06.02.2021.
//

import Foundation

class ApiWorkService {
    
    private let baseApiService = BaseApiService()
    
    
    func loadVacancies(completion: @escaping (_ faq: [VacancyResponse]?) -> Void) {
        baseApiService.load([VacancyResponse].self, url: ApiWork.allVacancies(), completion: completion)
    }
    
}
