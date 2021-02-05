//
//  ApiCampusService.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class ApiCampusService {
    
    private let baseApiService = BaseApiService()

    
    func postJoinToUnion(unionId: Int, fio: String, institute: String, group: String, vk: String, hobby: String, reason: String,
                         completion: @escaping (_ isDone: Bool) -> Void) {
        let task = baseApiService.session.dataTask(with: ApiCampus.joinToUnion(unionId: unionId,
                                                                               fio: fio,
                                                                               institute: institute,
                                                                               group: group,
                                                                               vk: vk,
                                                                               hobby: hobby,
                                                                               reason: reason)) { data, response, error in
            guard error == nil else {
                completion(false)
                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                completion(false)
                return
            }
            
            completion(true)
        }
        
        task.resume()
    }
    
    
    // TODO: Надо удалить функцию ниже и юзать ту, что в `baseApiService`
    func loadBuidlings(completion: @escaping (_ buildings: [BuidlingResponse]?) -> Void) {
        load([BuidlingResponse].self, url: ApiCampus.buildings(), completion: completion)
    }
    
    func loadInstitutes(completion: @escaping (_ institutes: [InstituteResponse]?) -> Void) {
        load([InstituteResponse].self, url: ApiCampus.institutes(), completion: completion)
    }
    
    // MARK: Student Life
    func loadUnions(completion: @escaping (_ unions: [UnionResponse]?) -> Void) {
        load([UnionResponse].self, url: ApiCampus.unions(), completion: completion)
    }
    
    func loadSportClubs(completion: @escaping (_ sportClubs: [SportClubResponse]?) -> Void) {
        baseApiService.load([SportClubResponse].self, url: ApiCampus.sportClubs(), completion: completion)
    }
    
    func loadDesingOffices(completion: @escaping (_ desingOffices: [DesignOfficeResponse]?) -> Void) {
        baseApiService.load([DesignOfficeResponse].self, url: ApiCampus.desingOffices(), completion: completion)
    }
    
    
    private func load<T: Decodable>(_ type: [T].Type, url: URL, completion: @escaping ([T]?) -> Void) where T: ConvertableToRealm {
        var downloadedObjects: [T]?
        
        let completionOperation = BlockOperation {
            completion(downloadedObjects)
        }
        
        let downloadingOperation = DownloadOperation(session: baseApiService.session, url: url) { data, response, error in
            guard let response = ResponseHandler.handleResponse([T].self, data, response, error) else {
                completion(nil)
                self.baseApiService.cancelAllDownloading()
                return
            }
            
            downloadedObjects = response
        }
        
        completionOperation.addDependency(downloadingOperation)
        
        baseApiService.downloadingQueue.addOperation(downloadingOperation)
        baseApiService.downloadingQueue.addOperation(completionOperation)
    }
    
}
