//
//  CampusService.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class CampusService {
    
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
    
    func getSportClubsFromLocal() -> [SportClub]? {
        let rSportClubs = DataManager.shared.getSportClubs()
        let sportClubs = Translator.shared.converteSportClubs(from: rSportClubs)
        
        if sportClubs.isEmpty {
            return nil
        } else {
            return sportClubs
        }
    }
    
    func getDesignOfficesFromLocal() -> [DesignOffice]? {
        let rDesignOffices = DataManager.shared.getDesingOffice()
        let designOffices = Translator.shared.convetreDesignOffices(from: rDesignOffices)
        
        if designOffices.isEmpty {
            return nil
        } else {
            return designOffices
        }
    }
    
    func getArtsFromLocal() -> [ArtAssociation]? {
        let arts = Translator.shared.converteArts(from: DataManager.shared.get(RArtAssociated.self))
        if arts.isEmpty { return nil }
        return arts
    }
    
    // MARK: - From Local or From API -
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
                DataManager.shared.deleteAllInstitutes()
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
                DataManager.shared.deleteAllUnions()
                let unions = unionsResponse.map { $0.converteToRealm() }
                DataManager.shared.write(unions: unions)
                let unionsForShowing = DataManager.shared.getUnions()
                completion(Translator.shared.converteUnions(from: unionsForShowing))
            }
        }
    }
    
    func getSportClubs(completion: @escaping ([SportClub]?) -> Void) {
        let sportClubsFromLocal = DataManager.shared.getSportClubs()
        
        ApiCampusService().loadSportClubs { sportClubsResponse in
            guard let sportClubsResponse = sportClubsResponse else {
                if sportClubsFromLocal.isEmpty {
                    completion(nil)
                } else {
                    DispatchQueue.main.async {
                        completion(Translator.shared.converteSportClubs(from: sportClubsFromLocal))
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                DataManager.shared.deleteAllSportClubs()
                let sportClubs = sportClubsResponse.map { $0.converteToRealm() }
                DataManager.shared.write(sportClubs: sportClubs)
                let sportClubsForShowing = DataManager.shared.getSportClubs()
                completion(Translator.shared.converteSportClubs(from: sportClubsForShowing))
            }
        }
    }
    
    func getDesignOffice(completion: @escaping ([DesignOffice]?) -> Void) {
        let designOfficeFromLocal = DataManager.shared.getDesingOffice()
        
        ApiCampusService().loadDesingOffices { designOfficesResponse in
            guard let designOfficesResponse = designOfficesResponse else {
                if designOfficeFromLocal.isEmpty {
                    completion(nil)
                } else {
                    DispatchQueue.main.async {
                        completion(Translator.shared.convetreDesignOffices(from: designOfficeFromLocal))
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                DataManager.shared.deleteAllDesingOffices()
                let designOffices = designOfficesResponse.map { $0.converteToRealm() }
                DataManager.shared.write(desingOffices: designOffices)
                let designOfficesForShowing = DataManager.shared.getDesingOffice()
                completion(Translator.shared.convetreDesignOffices(from: designOfficesForShowing))
            }
        }
    }
    
    func getArts(completion: @escaping ([ArtAssociation]?) -> Void) {
        let artsFromLocal = DataManager.shared.get(RArtAssociated.self)
        
        ApiCampusService().loadArts { optArts in
            guard let arts = optArts else {
                if artsFromLocal.isEmpty {
                    completion(nil)
                } else {
                    DispatchQueue.main.async {
                        completion(Translator.shared.converteArts(from: artsFromLocal))
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                DataManager.shared.deleteAll(RArtAssociated.self)
                DataManager.shared.write(objects: arts.map { $0.converteToRealm() })
                completion(Translator.shared.converteArts(from: DataManager.shared.get(RArtAssociated.self)))
            }
        }
    }
}
