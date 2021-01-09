//
//  CampusService.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class CampusService {
    
    // MARK: - From Local -
    func getBuildingsFromLocal() -> [Building]? {
        let rBuildings = DataManager.shared.getBuildings()
        let buildings = Translator.shared.converteBuildings(from: rBuildings)
        
        if buildings.isEmpty {
            return nil
        } else {
            return buildings
        }
    }
    
    func getInstitutesFromLocal() -> [Institute]? {
        let rInstitutes = DataManager.shared.getInstitutes()
        let institutes = Translator.shared.converteInstitutes(from: rInstitutes)
        
        if institutes.isEmpty {
            return nil
        } else {
            return institutes
        }
    }
    
    func getUnionsFromLocal() -> [Union]? {
        let rUnions = DataManager.shared.getUnions()
        let unions = Translator.shared.converteUnions(from: rUnions)
        
        if unions.isEmpty {
            return nil
        } else {
            return unions
        }
    }
    
    // MARK: - From Local or From API -
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
//        print("fine1")
        let unionsFromLocal = DataManager.shared.getUnions()
//        print("fine2")
        ApiCampusService().loadUnions { unionsResopnse in
//            print("fine3")
            guard let unionsResponse = unionsResopnse else {
//                print("fine4")
                if unionsFromLocal.isEmpty {
//                    print("fine5")
                    completion(nil)
                } else {
//                    print("fine6")
                    DispatchQueue.main.async {
//                        print("fine7")
                        completion(Translator.shared.converteUnions(from: unionsFromLocal))
                    }
                }
                return
            }
            
//            print("fine8")
            DispatchQueue.main.async {
                let unions = unionsResponse.map { $0.converteToRealm() }
                DataManager.shared.write(unions: unions)
                let unionsForShowing = DataManager.shared.getUnions()
                completion(Translator.shared.converteUnions(from: unionsForShowing))
            }
        }
    }
    
}
