//
//  CafetefiaService.swift
//  my-sibgu
//
//  Created by art-off on 21.02.2021.
//

import Foundation

class CafetefiaService {
    
    func getAllCafeterias(completion: @escaping ([Cafeteria]?) -> Void) {
        ApiCafeteriaService().loadCafeterias { cafeterias in
            completion(cafeterias?.map { $0.converteToDomain() })
        }
    }
    
}
