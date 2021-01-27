//
//  TimetableService.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class TimetableService {
    
    private let apiService = ApiTimetableService()
    
    // MARK: - Get Groups
    func getGroups(completion: @escaping (_ groups: [Group]?) -> Void) {
        let groups = DataManager.shared.getGroups()
        
        // Если есть, то даем
        if !groups.isEmpty {
            completion(Array(groups))
            return
        }
        // Иначе качаем
//        ApiTimetableService().loadGroupsAndGroupsHash { optionalGroupsHash, optionalGroups in
//            guard
//                let groupsHash = optionalGroupsHash,
//                let groups = optionalGroups
//            else {
//                completion(nil)
//                return
//            }
//            DispatchQueue.main.async {
//                UserDefaultsConfig.groupsHash = groupsHash
//                DataManager.shared.write(groups: groups)
//                completion(Array(DataManager.shared.getGroups()))
//            }
//        }
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
//        ApiTimetableService().loadGroupsAndGroupsHash { optionalGroupsHash, optionalGroups in
//            guard
//                let groupsHash = optionalGroupsHash,
//                let groups = optionalGroups
//            else {
//                completion(nil)
//                return
//            }
//            DispatchQueue.main.async {
//                UserDefaultsConfig.groupsHash = groupsHash
//                DataManager.shared.write(groups: groups)
//                completion(DataManager.shared.getGroup(withId: id))
//            }
//        }
    }
    
    
    // MARK: - NEW VERSION -
    func getGroupTimetable(
        withId id: Int,
        completion: @escaping (_ groupTimetable: GroupTimetable?) -> Void
    ) {
        _loadTimetable(timetableType: .group, withId: id) { timetableResponse in
            guard let timetableResponse = timetableResponse else {
                DispatchQueue.main.async {
                    let timetableFromLocal = DataManager.shared.getTimetable(forGroupId: id)
                    completion(timetableFromLocal)
                }
                return
            }
            
            DispatchQueue.main.async {
                let rTimetable = ResponseTranslator.converteTimetableResponseToRGroupTimetable(timetableResponse: timetableResponse, groupId: id)
                DataManager.shared.write(groupTimetable: rTimetable)
                let timetableForShowing = DataManager.shared.getTimetable(forGroupId: id)
                completion(timetableForShowing)
            }
        }
    }
    
    func getProfessorTimetable(
        withId id: Int,
        completion: @escaping (_ professorTimetable: ProfessorTimetable?) -> Void
    ) {
        _loadTimetable(timetableType: .professor, withId: id) { timetableResponse in
            guard let timetableResponse = timetableResponse else {
                DispatchQueue.main.async {
                    let timetableForShowing = DataManager.shared.getTimetable(forProfessorId: id)
                    completion(timetableForShowing)
                }
                return
            }
            
            DispatchQueue.main.async {
                let rTimetable = ResponseTranslator.converteTimetableResponseToProfessorTimetable(timetableResponse: timetableResponse, professorId: id)
                DataManager.shared.write(professorTimetable: rTimetable)
                let timetableForShowing = DataManager.shared.getTimetable(forProfessorId: id)
                completion(timetableForShowing)
            }
        }
    }
    
    func getPlaceTimetable(
        withId id: Int,
        completion: @escaping (_ placeTimetable: PlaceTimetable?) -> Void
    ) {
        _loadTimetable(timetableType: .place, withId: id) { timetableResponse in
            guard let timetableResponse = timetableResponse else {
                DispatchQueue.main.async {
                    let timetableFroShowing = DataManager.shared.getTimetable(forPlaceId: id)
                    completion(timetableFroShowing)
                }
                return
            }
            
            DispatchQueue.main.async {
                let rTimetable = ResponseTranslator.converteTimetableResponseToPlaceTimetable(timetableResponse: timetableResponse, placeId: id)
                DataManager.shared.write(placeTimetable: rTimetable)
                let timetableForShowing = DataManager.shared.getTimetable(forPlaceId: id)
                completion(timetableForShowing)
            }
        }
    }
    
    
    private func _loadTimetable(
        timetableType: EntitiesType,
        withId id: Int,
        completion: @escaping (_ timetableResponse: TimetableResponse?) -> Void
    ) {
        apiService.loadTimetable(timetableType: timetableType, withId: id) { timetableResponse in
            guard let timetableResponse = timetableResponse else {
                completion(nil)
                return
            }
            
            var missingEntities: Set<EntitiesType> = []
            if timetableResponse.meta.groupsHash != UserDefaultsConfig.groupsHash {
                missingEntities.insert(.group)
            }
            if timetableResponse.meta.professorHash != UserDefaultsConfig.professorsHash {
                missingEntities.insert(.professor)
            }
            if timetableResponse.meta.placesHash != UserDefaultsConfig.placesHash {
                missingEntities.insert(.place)
            }
            
            // Если все таблицы обновлены - отдаем расписание
            if missingEntities.isEmpty {
                completion(timetableResponse)
                return
            }
            // Иначе качаем недостающие таблицы
            self.apiService.loadEntities(entities: missingEntities) { result in
                if missingEntities.contains(.group) {
                    guard
                        let groups = result?.groups,
                        let groupsHash = result?.groupsHash
                    else {
                        completion(timetableResponse)
                        return
                    }
                    DispatchQueue.main.async {
                        print("other groups")
                        let rGroups = ResponseTranslator.converteGroupResponseToRGroup(groupsResponse: groups)
                        DataManager.shared.write(groups: rGroups)
                        UserDefaultsConfig.groupsHash = groupsHash
                    }
                }
                
                if missingEntities.contains(.professor) {
                    guard
                        let professors = result?.professors,
                        let professorsHash = result?.professorsHash
                    else {
                        completion(timetableResponse)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        print("other professors")
                        let rProfessors = ResponseTranslator.converteProfessorResponseToRProfessor(professorsResponse: professors)
                        DataManager.shared.write(professors: rProfessors)
                        UserDefaultsConfig.professorsHash = professorsHash
                    }
                }
                
                if missingEntities.contains(.place) {
                    guard
                        let places = result?.places,
                        let placesHash = result?.placesHash
                    else {
                        completion(timetableResponse)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        print("other places")
                        let rPlaces = ResponseTranslator.convertePlaceResponseToRPlace(placesResponse: places)
                        DataManager.shared.write(places: rPlaces)
                        UserDefaultsConfig.placesHash = placesHash
                    }
                }
                DispatchQueue.main.async {
                    completion(timetableResponse)
                }
            }
            
        }
    }
    
//    func loadTimetablea(
//        timetableType: EntitiesType,
//        withId id: Int,
//        completion: @escaping (_ timetableResponse: GroupTimetable?) -> Void) {
////
////        apiService.loadTimetable(
////            timetableType: timetableType,
////            withId: id,
////            completion: { timetableResponse in
////                guard let timetableResponse = timetableResponse else {
////                    DispatchQueue.main.async {
////                        let timetableFromLocal = DataManager.shared.getTimetable(forGroupId: id)
////                        completion(timetableFromLocal)
////                    }
////                    return
////                }
////
////                if timetableResponse.meta.groupsHash != UserDefaultsConfig.groupsHash {
////
////                }
////            }
////        )
//    }
    
    
    // MARK: - END NEW VERSION -
    
    // MARK: - Get Group Timetable
//    func loadTimetable(withId id: Int,
//                      completionIfNeedNotLoadGroups: @escaping (_ groupTimetable: Timetable?) -> Void,
//                      startIfNeedLoadGroups: @escaping () -> Void,
//                      completionIfNeedLoadGroups: @escaping (_ groupTimetable: Timetable?) -> Void) {
//        ApiTimetableService().loadGroupTimetable(
//            withId: id,
//            completionIfNeedNotLoadGroups: { optionalGroupHash, optionalGroupTimetable in
//                guard
//                    let _ = optionalGroupHash,
//                    let groupTimetable = optionalGroupTimetable
//                else {
//                    DispatchQueue.main.async {
//                        let timetableFromLocal = DataManager.shared.getTimetable(forGroupId: id)
//                        completionIfNeedNotLoadGroups(timetableFromLocal)
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    DataManager.shared.write(groupTimetable: groupTimetable)
//                    let timetableForShowing = DataManager.shared.getTimetable(forGroupId: groupTimetable.objectId)
//                    completionIfNeedNotLoadGroups(timetableForShowing)
//                }
//            },
//            startIfNeedLoadGroups: startIfNeedLoadGroups,
//            completionIfNeedLoadGroups: { optionalGroupsHash, optionalGroups, optionalGroupTimetable in
//                guard
//                    let groupHash = optionalGroupsHash,
//                    let groups = optionalGroups,
//                    let groupTimetable = optionalGroupTimetable
//                else {
//                    DispatchQueue.main.async {
//                        let timetableFromLocal = DataManager.shared.getTimetable(forGroupId: id)
//                        completionIfNeedNotLoadGroups(timetableFromLocal)
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    UserDefaultsConfig.groupsHash = groupHash
//                    DataManager.shared.write(groups: groups)
//                    DataManager.shared.write(groupTimetable: groupTimetable)
//                    let timetableForShowing = DataManager.shared.getTimetable(forGroupId: groupTimetable.objectId)
//                    completionIfNeedLoadGroups(timetableForShowing)
//                }
//            }
//        )
//    }
    
    // MARK: - Helpers Method
    func saveTimetableTypeAndIdToUserDefaults(type: EntitiesType?, id: Int?) {
        UserDefaultsConfig.timetableType = type?.rawValue ?? nil
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
