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
        ApiCampusService().loadBuidlings { buildingsResponse in
            // Если не вышло скачать - пытаемся показать то, что сохранено в БД
            guard let buildingsResponse = buildingsResponse else {
                if buildingsFromLocal.isEmpty {
                    completion(nil)
                } else {
                    DispatchQueue.main.async {
                        completion(Translator.shared.converteBuildings(from: buildingsFromLocal))
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                let buildings = buildingsResponse.map { $0.converteToRealm() }
                DataManager.shared.write(buildings: buildings)
                let buildingsForShowing = DataManager.shared.getBuildings()
                completion(Translator.shared.converteBuildings(from: buildingsForShowing))
            }
        }
    }
    
    func getInstitutes(completion: @escaping ([Institute]?) -> Void) {
        let institutsFromLocal = DataManager.shared.getInstitutes()
        ApiCampusService().loadInstitutes { institutesResponse in
            guard let institutesResponse = institutesResponse else {
                if institutsFromLocal.isEmpty {
                    completion(nil)
                } else {
                    DispatchQueue.main.async {
                        completion(Translator.shared.converteInstitutes(from: institutsFromLocal))
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                let institutes = institutesResponse.map { $0.converteToRealm() }
                DataManager.shared.write(institutes: institutes)
                let institutesForShowing = DataManager.shared.getInstitutes()
                completion(Translator.shared.converteInstitutes(from: institutesForShowing))
            }
        }
    }
    
    func getUnions(completion: @escaping ([Union]?) -> Void) {
        let unionsFromLocal = DataManager.shared.getUnions()
        ApiCampusService().loadUnions { unionsResopnse in
            guard let unionsResponse = unionsResopnse else {
                if unionsFromLocal.isEmpty {
                    completion(nil)
                } else {
                    DispatchQueue.main.async {
                        completion(Translator.shared.converteUnions(from: unionsFromLocal))
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                let unions = unionsResponse.map { $0.converteToRealm() }
                DataManager.shared.write(unions: unions)
                let unionsForShowing = DataManager.shared.getUnions()
                completion(Translator.shared.converteUnions(from: unionsForShowing))
            }
        }
    }
    
}
