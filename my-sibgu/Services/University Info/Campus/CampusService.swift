//
//  CampusService.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class CampusService {
    
    func getBuildings(completion: @escaping ([Building]?) -> Void) {
        let buildingsFromLocal = DataManager.shared.getBuildings()
        ApiCampusService().loadBuidlings { optionalBuildings in
            // Если не вышло скачать - пытаемся показать то, что сохранено в БД
            guard let buidlingsFromApi = optionalBuildings else {
                if buildingsFromLocal.isEmpty {
                    completion(nil)
                } else {
                    completion(Translator.shared.converteBuildings(from: buildingsFromLocal))
                }
                return
            }
            
            DispatchQueue.main.async {
                DataManager.shared.write(buildings: buidlingsFromApi)
                let buildingsForShowing = DataManager.shared.getBuildings()
                completion(Translator.shared.converteBuildings(from: buildingsForShowing))
            }
        }
    }
    
    func getInstituts(completion: @escaping ([Institute]) -> Void) {
        
    }
    
    func getUnions(completion: @escaping ([Union]) -> Void) {
        
    }
    
}
