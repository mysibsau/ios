//
//  TimetableService.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

typealias EntitiesSet = (
    groups: [Group],
    professors: [Professor],
    places: [Place]
)
typealias EntitiesCallback = (EntitiesSet) -> Void

class TimetableService {
    
    private let apiService = ApiTimetableService()
    
    // MARK: - Get Groups
    func getEntities(ofTypes: Set<EntitiesType>, completion: @escaping EntitiesCallback) {
//        var groups = DataManager.shared.getGroups()
//        var professors = DataManager.shared.getProfessors()
//        var places = DataManager.shared.getPlaces()
//
//        var missingEntities: Set<EntitiesType> = []
//        if groups.isEmpty {
//            missingEntities.insert(.group)
//        }
//        if professors.isEmpty {
//            missingEntities.insert(.professor)
//        }
//        if places.isEmpty {
//            missingEntities.insert(.place)
//        }
//
//        // Если все есть - возвращаем
//        if missingEntities.isEmpty {
//            completion((groups, professors, places))
//            return
//        }
        var missingEntities: Set<EntitiesType> = ofTypes
        
        // Иначе качаем недостающие
        ApiTimetableService().loadEntities(entities: missingEntities) { result in
            // Лучше не вытаскивать из main, потому что в предыдущей функции почти все запускатеся
            // в main потоке и нижний код может выполниться быстрее
            DispatchQueue.main.async {
                self.saveEntities(entitiesTypes: missingEntities, result: result)
                // Await save entities hehehehe
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    completion((DataManager.shared.getGroups(), DataManager.shared.getProfessors(), DataManager.shared.getPlaces()))
                }
            }
        }
        
    }
    
    
    func getGroupsFromLocal() -> [Group] {
        let groups = DataManager.shared.getGroups()
        return groups
    }
    
    func getProfessorsFromLocal() -> [Professor] {
        return DataManager.shared.getProfessors()
    }
    
    func getPlacesFromLocal() -> [Place] {
        return DataManager.shared.getPlaces()
    }
    
    // MARK: - Favorite
    // MARK: Groups
//    func getFavoriteGroupsFromLocal() -> [Group] {
//        return DataManager.shared.getFavoriteGroups()
//    }
//
//    func addFavorite(groupId: Int) {
//        DataManager.shared.writeFavorite(groupId: groupId)
//    }
//
//    func deleteFavorite(groupId: Int) {
//        DataManager.shared.deleteFavorite(groupId: groupId)
//    }
//
    // MARK: Professors
//    func getFavoriteProfessorsFromLocal() -> [Professor] {
//        return DataManager.shared.getFavoriteProfessors()
//    }
    
//    func addFavorite(professorId: Int) {
//        DataManager.shared.writeFavorite(professorId: professorId)
//    }
//
//    func deleteFavorite(professorId: Int) {
//        DataManager.shared.deleteFavorite(professorId: professorId)
//    }
//
    // MARK: Places
//    func getFavoritePlacesFromLocal() -> [Place] {
//        return DataManager.shared.getFavoritePlaces()
//    }
//
//    func addFavorite(placeId: Int) {
//        DataManager.shared.writeFavorite(placeId: placeId)
//    }
//
//    func deleteFavorite(placeId: Int) {
//        DataManager.shared.deleteFavorite(placeId: placeId)
//    }
//
    func getFavoritesFromLocal() -> [TimetableEntity] {
        return DataManager.shared.getFavorites().reversed()
    }
    
    func addFavorite(entity: SavedEntity) {
        DataManager.shared.writeFavorite(entity: entity)
    }
    
    func deleteFavorite(entity: SavedEntity) {
        DataManager.shared.deleteFavorite(entity: entity)
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
                self.saveEntities(entitiesTypes: missingEntities, result: result)
                DispatchQueue.main.async {
                    completion(timetableResponse)
                }
            }
            
        }
    }
    
    private func saveEntities(entitiesTypes: Set<EntitiesType>, result: EntitiesResponse?) {
        if entitiesTypes.contains(.group) {
            if let groups = result?.groups,
               let groupsHash = result?.groupsHash {
                DispatchQueue.main.async {
                    DataManager.shared.deleteAllGroups()
                    let rGroups = ResponseTranslator.converteGroupResponseToRGroup(groupsResponse: groups)
                    DataManager.shared.write(groups: rGroups)
                    UserDefaultsConfig.groupsHash = groupsHash
                }
            }
        }
        
        if entitiesTypes.contains(.professor) {
            if let professors = result?.professors,
               let professorsHash = result?.professorsHash {
                DispatchQueue.main.async {
                    DataManager.shared.deleteAllProfessors()
                    let rProfessors = ResponseTranslator.converteProfessorResponseToRProfessor(professorsResponse: professors)
                    DataManager.shared.write(professors: rProfessors)
                    UserDefaultsConfig.professorsHash = professorsHash
                }
            }
        }
        
        if entitiesTypes.contains(.place) {
            if let places = result?.places,
               let placesHash = result?.placesHash {
                DispatchQueue.main.async {
                    DataManager.shared.deleteAllPlaces()
                    let rPlaces = ResponseTranslator.convertePlaceResponseToRPlace(placesResponse: places)
                    DataManager.shared.write(places: rPlaces)
                    UserDefaultsConfig.placesHash = placesHash
                }
            }
        }
    }
    
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
