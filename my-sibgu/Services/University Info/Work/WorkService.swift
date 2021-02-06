//
//  WorkService.swift
//  my-sibgu
//
//  Created by art-off on 06.02.2021.
//

import Foundation

class WorkService {
    
    func getAllVacancies(completion: @escaping ([Vacancy]?) -> Void) {
        ApiWorkService().loadVacancies { vacancies in
            completion(vacancies?.map { $0.converteToDomain() })
        }
    }
    
}
