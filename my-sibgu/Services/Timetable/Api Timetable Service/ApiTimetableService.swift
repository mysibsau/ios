//
//  ApiTimetableService.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

typealias EntitiesResponse = (
    groups: [GroupResponse]?, groupsHash: String?,
    professors: [ProfessorResponse]?, professorsHash: String?,
    places: [PlaceResponse]?, placesHash: String?
)
typealias EntitiesLoadingCallback =  (EntitiesResponse?) -> Void


class ApiTimetableService {
    
    private let baseApiService = BaseApiService()
    
    
//    // MARK: - Скачивание группы и хэша
//    func loadGroupsAndGroupsHash(completion: @escaping (_ groupsHash: String?, _ groups: [RGroup]?) -> Void) {
//        var downloadedGroupsHash: String?
//        var downloadedGroups: [RGroup]?
//
//        let completionOperation = BlockOperation {
//            completion(downloadedGroupsHash, downloadedGroups)
//        }
//
//        let groupsDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.groups()) { data, response, error in
//            guard let groups = TimetableResponseHandler.handleGroupsResponse(data, response, error) else {
//                completion(nil, nil)
//                self.baseApiService.cancelAllDownloading()
//                return
//            }
//
//            downloadedGroups = groups
//        }
//
//        let hashDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.groupsHash()) { data, response, error in
//            guard let hash = TimetableResponseHandler.handleHashResponse(data, response, error) else {
//                completion(nil, nil)
//                self.baseApiService.cancelAllDownloading()
//                return
//            }
//
//            downloadedGroupsHash = hash
//        }
//
//        completionOperation.addDependency(groupsDownloadOperation)
//        completionOperation.addDependency(hashDownloadOperation)
//
//        baseApiService.downloadingQueue.addOperation(groupsDownloadOperation)
//        baseApiService.downloadingQueue.addOperation(hashDownloadOperation)
//        baseApiService.downloadingQueue.addOperation(completionOperation)
//    }
//
    
    // MARK: - Скачивание расписания для группы -
    func loadTimetable(
        timetableType: EntitiesType,
        withId id: Int,
        completion: @escaping (_ timetableResponse: TimetableResponse?) -> Void
    ) {
        let url: URLRequest
        switch timetableType {
        case .group: url = ApiTimetable.timetable(forGroupId: id)
        case .professor: url = ApiTimetable.timetable(forProfessorId: id)
        case .place: url = ApiTimetable.timetable(forPlaceId: id)
        }
        
        baseApiService.load(TimetableResponse.self, url: url, completion: completion)
    }
    
    func loadEntities(
        entities: Set<EntitiesType>,
        completion: @escaping EntitiesLoadingCallback) {
        
        var downloadedOperations: [DownloadOperation] = []
        
        var downloadedGroups: [GroupResponse]?
        var downloadedGroupsHash: String?
        var downloadedProfessors: [ProfessorResponse]?
        var downloadedProfessorsHash: String?
        var downloadedgPlaces: [PlaceResponse]?
        var downloadedPlacesHash: String?
        
        let completionOperation = BlockOperation {
            let response: EntitiesResponse = (
                groups: downloadedGroups,
                groupsHash: downloadedGroupsHash,
                professors: downloadedProfessors,
                professorsHash: downloadedProfessorsHash,
                places: downloadedgPlaces,
                placesHash: downloadedPlacesHash
            )
            completion(response)
        }
        
        for entity in entities {
            let objectsUrl: URL
            let hashUrl: URL
            switch entity {
            case .group:
                objectsUrl = ApiTimetable.groups()
                hashUrl = ApiTimetable.groupsHash()
            case .professor:
                objectsUrl = ApiTimetable.professors()
                hashUrl = ApiTimetable.professorsHash()
            case .place:
                objectsUrl = ApiTimetable.places()
                hashUrl = ApiTimetable.placesHash()
            }
            
            let downloadOperationObjects = DownloadOperation(session: baseApiService.session, url: objectsUrl) { data, response, error in
                switch entity {
                case .group:
                    let objects = self.handle([GroupResponse].self, data, response, error)
                    downloadedGroups = objects
                case .professor:
                    let objects = self.handle([ProfessorResponse].self, data, response, error)
                    downloadedProfessors = objects
                case .place:
                    let objects = self.handle([PlaceResponse].self, data, response, error)
                    downloadedgPlaces = objects
                }
            }
            
            let downloadedOperationHash = DownloadOperation(session: baseApiService.session, url: hashUrl) { data, response, error in
                let hash = self.handle(HashResponse.self, data, response, error)?.hash
                switch entity {
                case .group:
                    downloadedGroupsHash = hash
                case .professor:
                    downloadedProfessorsHash = hash
                case .place:
                    downloadedPlacesHash = hash
                }
            }
            
            downloadedOperations.append(downloadOperationObjects)
            downloadedOperations.append(downloadedOperationHash)
            
            completionOperation.addDependency(downloadOperationObjects)
            completionOperation.addDependency(downloadedOperationHash)
        }
        
        for operation in downloadedOperations {
            baseApiService.downloadingQueue.addOperation(operation)
        }
        baseApiService.downloadingQueue.addOperation(completionOperation)
    }
    
    private func handle<T: Decodable>(_ type: T.Type, _ data: Data?, _ response: URLResponse?, _ error: Error?) -> T? {
        guard
            error == nil,
            let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode),
            let data = data
        else {
            return nil
        }
        
        do {
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch let jsonError {
            print(jsonError)
            return nil
        }
    }
    // MARK: - END -
//
//
//    func loadGroupTimetable(withId id: Int,
//                            completionIfNeedNotLoadGroups: @escaping (_ groupsHash: String?, _ groupTimetable: RTimetable?) -> Void,
//                            startIfNeedLoadGroups: @escaping () -> Void,
//                            completionIfNeedLoadGroups: @escaping (_ groupsHash: String?, _ groups: [RGroup]?, _ groupTimetable: RTimetable?) -> Void) {
//        var downloadedGroupTimetable: RTimetable?
//        var downloadedGroupsHash: String?
//
//        let completionOperation = BlockOperation {
//            guard
//                let downloadedGroupTimetable = downloadedGroupTimetable,
//                let downloadedGroupsHash = downloadedGroupsHash
//            else {
//                completionIfNeedNotLoadGroups(nil, nil)
//                return
//            }
//
//            if downloadedGroupsHash == UserDefaultsConfig.groupsHash {
//                completionIfNeedNotLoadGroups(downloadedGroupsHash, downloadedGroupTimetable)
//            } else {
//                startIfNeedLoadGroups()
//                self.loadGroupsAndGroupsHashForLoadTimetable(groupTimegable: downloadedGroupTimetable, completion: completionIfNeedLoadGroups)
//            }
//        }
//
//        let groupTimetableDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.timetable(forGroupId: id)) { data, response, error in
//            let (optionalGroupTimetable, optionalGroupHash) = TimetableResponseHandler.handleGroupTimetableResponse(groupId: id, data, response, error)
//
//            guard
//                let groupTimetable = optionalGroupTimetable,
//                let groupHash = optionalGroupHash
//            else {
//                // Есил не вышло скачать - прекращаем все загрузки и пытаемся открыть старое
//                self.baseApiService.cancelAllDownloading()
//                completionIfNeedNotLoadGroups(nil, nil)
//                return
//            }
//
//            downloadedGroupsHash = groupHash
//            downloadedGroupTimetable = groupTimetable
//        }
//
//        // Добавляем зависимости
//        completionOperation.addDependency(groupTimetableDownloadOperation)
//
//        // Добавляем все в очередь
//        baseApiService.downloadingQueue.addOperation(groupTimetableDownloadOperation)
//        baseApiService.downloadingQueue.addOperation(completionOperation)
//    }
//
//    private func loadGroupsAndGroupsHashForLoadTimetable(groupTimegable: RTimetable, completion: @escaping (_ groupsHash: String?, _ groups: [RGroup]?, _ groupTimetable: RTimetable?) -> Void) {
//        var downloadedGroupsHash: String?
//        var downloadedGroups: [RGroup]?
//
//        let completionOperation = BlockOperation {
//            completion(downloadedGroupsHash, downloadedGroups, groupTimegable)
//        }
//
//        let groupsDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.groups()) { data, response, error in
//            guard let groups = TimetableResponseHandler.handleGroupsResponse(data, response, error) else {
//                completion(nil, nil, nil)
//                self.baseApiService.cancelAllDownloading()
//                return
//            }
//
//            downloadedGroups = groups
//        }
//
//        let hashDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.groupsHash()) { data, response, error in
//            guard let hash = TimetableResponseHandler.handleHashResponse(data, response, error) else {
//                completion(nil, nil, nil)
//                self.baseApiService.cancelAllDownloading()
//                return
//            }
//
//            downloadedGroupsHash = hash
//        }
//
//        completionOperation.addDependency(groupsDownloadOperation)
//        completionOperation.addDependency(hashDownloadOperation)
//
//        baseApiService.downloadingQueue.addOperation(groupsDownloadOperation)
//        baseApiService.downloadingQueue.addOperation(hashDownloadOperation)
//        baseApiService.downloadingQueue.addOperation(completionOperation)
//    }

}
