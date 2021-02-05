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

}
