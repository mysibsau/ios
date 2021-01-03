//
//  ApiCampusService.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class ApiCampusService {
    
    private let baseApiService = BaseApiService()
    
    
    func loadBuidlings(completion: @escaping (_ buildings: [RBuilding]?) -> Void) {
        load([BuidlingResponse].self, url: ApiCampus.buildings(), completion: completion)
    }
    
    func loadUnions(completion: @escaping (_ unions: [RUnion]?) -> Void) {
        load([UnionResponse].self, url: ApiCampus.unions(), completion: completion)
    }
    
    func loadInstitutes(completion: @escaping (_ institutes: [RInstitute]?) -> Void) {
        load([InstituteResponse].self, url: ApiCampus.institutes(), completion: completion)
    }
    
    
    private func load<T: Decodable>(_ type: [T].Type, url: URL, completion: @escaping ([T.RealmProtocol]?) -> Void) where T: ConvertableToRealm {
        var downloadedObjects: [T.RealmProtocol]?
        
        let completionOperation = BlockOperation {
            completion(downloadedObjects)
        }
        
        let downloadingOperation = DownloadOperation(session: baseApiService.session, url: url) { data, response, error in
            guard let response = ResponseHandler.handleResponse([T].self, data, response, error) else {
                completion(nil)
                self.baseApiService.cancelAllDownloading()
                return
            }
            
            downloadedObjects = response.map { $0.converteToRealm() }
        }
        
        completionOperation.addDependency(downloadingOperation)
        
        baseApiService.downloadingQueue.addOperation(downloadingOperation)
        baseApiService.downloadingQueue.addOperation(completionOperation)
    }
    
}