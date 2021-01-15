//
//  ApiTimetableService.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class ApiTimetableService {
    
    private let baseApiService = BaseApiService()
    
    
    // MARK: - Скачивание группы и хэша
    func loadGroupsAndGroupsHash(completion: @escaping (_ groupsHash: String?, _ groups: [RGroup]?) -> Void) {
        var downloadedGroupsHash: String?
        var downloadedGroups: [RGroup]?

        let completionOperation = BlockOperation {
            completion(downloadedGroupsHash, downloadedGroups)
        }

        let groupsDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.groups()) { data, response, error in
            guard let groups = TimetableResponseHandler.handleGroupsResponse(data, response, error) else {
                completion(nil, nil)
                self.baseApiService.cancelAllDownloading()
                return
            }
            
            downloadedGroups = groups
        }
        
        let hashDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.groupsHash()) { data, response, error in
            guard let hash = TimetableResponseHandler.handleHashResponse(data, response, error) else {
                completion(nil, nil)
                self.baseApiService.cancelAllDownloading()
                return
            }
            
            downloadedGroupsHash = hash
        }

        completionOperation.addDependency(groupsDownloadOperation)
        completionOperation.addDependency(hashDownloadOperation)

        baseApiService.downloadingQueue.addOperation(groupsDownloadOperation)
        baseApiService.downloadingQueue.addOperation(hashDownloadOperation)
        baseApiService.downloadingQueue.addOperation(completionOperation)
    }
    
    
    // MARK: - Скачивание расписания для группы
    func loadGroupTimetable(withId id: Int,
                            completionIfNeedNotLoadGroups: @escaping (_ groupsHash: String?, _ groupTimetable: RGroupTimetable?) -> Void,
                            startIfNeedLoadGroups: @escaping () -> Void,
                            completionIfNeedLoadGroups: @escaping (_ groupsHash: String?, _ groups: [RGroup]?, _ groupTimetable: RGroupTimetable?) -> Void) {
        var downloadedGroupTimetable: RGroupTimetable?
        var downloadedGroupsHash: String?
        
        let completionOperation = BlockOperation {
            guard
                let downloadedGroupTimetable = downloadedGroupTimetable,
                let downloadedGroupsHash = downloadedGroupsHash
            else {
                completionIfNeedNotLoadGroups(nil, nil)
                return
            }
            
            if downloadedGroupsHash == UserDefaultsConfig.groupsHash {
                completionIfNeedNotLoadGroups(downloadedGroupsHash, downloadedGroupTimetable)
            } else {
                startIfNeedLoadGroups()
                self.loadGroupsAndGroupsHashForLoadTimetable(groupTimegable: downloadedGroupTimetable, completion: completionIfNeedLoadGroups)
            }
        }
        
        let groupTimetableDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.timetable(forGroupId: id)) { data, response, error in
            let (optionalGroupTimetable, optionalGroupHash) = TimetableResponseHandler.handleGroupTimetableResponse(groupId: id, data, response, error)
            
            guard
                let groupTimetable = optionalGroupTimetable,
                let groupHash = optionalGroupHash
            else {
                // Есил не вышло скачать - прекращаем все загрузки и пытаемся открыть старое
                self.baseApiService.cancelAllDownloading()
                completionIfNeedNotLoadGroups(nil, nil)
                return
            }
            
            downloadedGroupsHash = groupHash
            downloadedGroupTimetable = groupTimetable
        }
        
        // Добавляем зависимости
        completionOperation.addDependency(groupTimetableDownloadOperation)
        
        // Добавляем все в очередь
        baseApiService.downloadingQueue.addOperation(groupTimetableDownloadOperation)
        baseApiService.downloadingQueue.addOperation(completionOperation)
    }
    
    private func loadGroupsAndGroupsHashForLoadTimetable(groupTimegable: RGroupTimetable, completion: @escaping (_ groupsHash: String?, _ groups: [RGroup]?, _ groupTimetable: RGroupTimetable?) -> Void) {
        var downloadedGroupsHash: String?
        var downloadedGroups: [RGroup]?

        let completionOperation = BlockOperation {
            completion(downloadedGroupsHash, downloadedGroups, groupTimegable)
        }

        let groupsDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.groups()) { data, response, error in
            guard let groups = TimetableResponseHandler.handleGroupsResponse(data, response, error) else {
                completion(nil, nil, nil)
                self.baseApiService.cancelAllDownloading()
                return
            }
            
            downloadedGroups = groups
        }
        
        let hashDownloadOperation = DownloadOperation(session: baseApiService.session, url: ApiTimetable.groupsHash()) { data, response, error in
            guard let hash = TimetableResponseHandler.handleHashResponse(data, response, error) else {
                completion(nil, nil, nil)
                self.baseApiService.cancelAllDownloading()
                return
            }
            
            downloadedGroupsHash = hash
        }

        completionOperation.addDependency(groupsDownloadOperation)
        completionOperation.addDependency(hashDownloadOperation)

        baseApiService.downloadingQueue.addOperation(groupsDownloadOperation)
        baseApiService.downloadingQueue.addOperation(hashDownloadOperation)
        baseApiService.downloadingQueue.addOperation(completionOperation)
    }

}
