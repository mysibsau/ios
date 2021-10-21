//
//  ApiCampusService.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class ApiCampusService {
    
    private let baseApiService = BaseApiService()

    
    func postJoinToUnion(unionId: Int, fio: String, institute: String,
                         group: String, vk: String, hobby: String, reason: String,
                         completion: @escaping (_ isDone: Bool) -> Void) {
        
        baseApiService.sendPost(request: ApiCampus.joinToUnion(unionId: unionId,
                                                               fio: fio,
                                                               institute: institute,
                                                               group: group,
                                                               vk: vk,
                                                               hobby: hobby,
                                                               reason: reason),
                                completion: completion)
    }
    
    func postJoinToFaculty(facultyId: Int, fio: String, institute: String,
                           group: String, vk: String, hobby: String, reason: String,
                           completion: @escaping (_ isDone: Bool) -> Void) {
        
        baseApiService.sendPost(request: ApiCampus.joinToFaculty(facultyId: facultyId,
                                                                 fio: fio,
                                                                 institute: institute,
                                                                 group: group,
                                                                 vk: vk,
                                                                 hobby: hobby,
                                                                 reason: reason),
                                completion: completion)
    }
    
    func postJoinToArt(artId: Int, fio: String, phone: String,
                       vkLink: String, experience: String, comment: String,
                       completion: @escaping (_ done: Bool) -> Void) {
        baseApiService.sendPost(request: ApiCampus.joinToArt(artId: artId, fio: fio, phone: phone,
                                                             vkLink: vkLink, experience: experience,
                                                             comment: comment),
                                completion: completion)
    }
    
    
    // TODO: Надо удалить функцию ниже и юзать ту, что в `baseApiService`
    
    func loadInstitutes(completion: @escaping (_ institutes: [InstituteResponse]?) -> Void) {
        load([InstituteResponse].self, urlRequest: ApiCampus.institutes(), completion: completion)
    }
    
    // MARK: Student Life
    func loadUnions(completion: @escaping (_ unions: [UnionResponse]?) -> Void) {
        load([UnionResponse].self, urlRequest: ApiCampus.unions(), completion: completion)
    }
    
    func loadSportClubs(completion: @escaping (_ sportClubs: [SportClubResponse]?) -> Void) {
        baseApiService.load([SportClubResponse].self, url: ApiCampus.sportClubs(), completion: completion)
    }
    
    func loadDesingOffices(completion: @escaping (_ desingOffices: [DesignOfficeResponse]?) -> Void) {
        baseApiService.load([DesignOfficeResponse].self, url: ApiCampus.desingOffices(), completion: completion)
    }
    
    
    private func load<T: Decodable>(_ type: [T].Type, urlRequest: URLRequest, completion: @escaping ([T]?) -> Void) where T: ConvertableToRealm {
        var downloadedObjects: [T]?
        
        let completionOperation = BlockOperation {
            completion(downloadedObjects)
        }
        
        let downloadingOperation = DownloadOperation(session: baseApiService.session, urlRequest: urlRequest) { data, response, error in
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
