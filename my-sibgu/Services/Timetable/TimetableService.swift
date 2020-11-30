//
//  TimetableService.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class TimetableService {
    
    // MARK: - Get Groups
    func getGroups(completion: @escaping (_ groups: [Group]?) -> Void) {
        let groups = DataManager.shared.getGroups()
        
        // Если есть, то даем
        if !groups.isEmpty {
            completion(Array(groups))
            return
        }
        // Иначе качаем
        ApiTimetableService().loadGroupsAndGroupsHash { optionalGroupsHash, optionalGroups in
            guard
                let groupsHash = optionalGroupsHash,
                let groups = optionalGroups
            else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                UserDefaultsConfig.groupsHash = groupsHash
                DataManager.shared.write(groups: groups)
                completion(Array(DataManager.shared.getGroups()))
            }
        }
    }
    
    func getGroupsFromLocal() -> [Group] {
        let groups = DataManager.shared.getGroups()
        return groups
    }
    
    func getGroup(withId id: Int, completion: @escaping (_ groups: Group?) -> Void) {
        let group = DataManager.shared.getGroup(withId: id)
        
        // Если есть, то даем
        if group != nil {
            completion(group)
            return
        }
        // Иначе качаем
        ApiTimetableService().loadGroupsAndGroupsHash { optionalGroupsHash, optionalGroups in
            guard
                let groupsHash = optionalGroupsHash,
                let groups = optionalGroups
            else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                UserDefaultsConfig.groupsHash = groupsHash
                DataManager.shared.write(groups: groups)
                completion(DataManager.shared.getGroup(withId: id))
            }
        }
    }
    
    // MARK: - Get Group Timetable
    func loadTimetable(withId id: Int,
                      completionIfNeedNotLoadGroups: @escaping (_ groupTimetable: GroupTimetable?) -> Void,
                      startIfNeedLoadGroups: @escaping () -> Void,
                      completionIfNeedLoadGroups: @escaping (_ groupTimetable: GroupTimetable?) -> Void) {
        ApiTimetableService().loadGroupTimetable(
            withId: id,
            completionIfNeedNotLoadGroups: { optionalGroupHash, optionalGroupTimetable in
                guard
                    let _ = optionalGroupHash,
                    let groupTimetable = optionalGroupTimetable
                else {
                    completionIfNeedNotLoadGroups(nil)
                    return
                }
                DispatchQueue.main.async {
                    DataManager.shared.write(groupTimetable: groupTimetable)
                    let timetableForShowing = DataManager.shared.getTimetable(forGroupId: groupTimetable.groupId)
                    completionIfNeedNotLoadGroups(timetableForShowing)
                }
            },
            startIfNeedLoadGroups: startIfNeedLoadGroups,
            completionIfNeedLoadGroups: { optionalGroupsHash, optionalGroups, optionalGroupTimetable in
                guard
                    let groupHash = optionalGroupsHash,
                    let groups = optionalGroups,
                    let groupTimetable = optionalGroupTimetable
                else {
                    completionIfNeedLoadGroups(nil)
                    return
                }
                DispatchQueue.main.async {
                    UserDefaultsConfig.groupsHash = groupHash
                    DataManager.shared.write(groups: groups)
                    DataManager.shared.write(groupTimetable: groupTimetable)
                    let timetableForShowing = DataManager.shared.getTimetable(forGroupId: groupTimetable.groupId)
                    completionIfNeedLoadGroups(timetableForShowing)
                }
            }
        )
    }
    
    // MARK: - Helpers Method
    func saveTimetableTypeAndIdToUserDefaults(type: EntitiesType?, id: Int?) {
        UserDefaultsConfig.timetableType = type?.raw ?? nil
        UserDefaultsConfig.timetableId = id
    }
    
    func getTimetableTypeAndIdFromUserDefaults() -> (EntitiesType?, id: Int?) {
        let stringType = UserDefaultsConfig.timetableType
        let id = UserDefaultsConfig.timetableId
        
        var type: EntitiesType? = nil
        if let st = stringType {
            type = EntitiesType(rawValue: st)
        }
        
        return (type, id)
    }
    
}
