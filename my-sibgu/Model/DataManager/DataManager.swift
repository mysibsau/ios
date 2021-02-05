//
//  DataManager.swift
//  my-sibgu
//
//  Created by art-off on 12.11.2020.
//

import Foundation
import RealmSwift

class DataManager {
    
    static let shared = DataManager()
    
    
    @UserDefaultsWrapper(key: "favorite-groups-id", defaultValue: [Int]())
    private var favoriteGroupsId: [Int]
    
    @UserDefaultsWrapper(key: "favorite-professors-id", defaultValue: [Int]())
    private var favoriteProfessorsId: [Int]
    
    @UserDefaultsWrapper(key: "favorite-places-id", defaultValue: [Int]())
    private var favoritePlacesId: [Int]
    
    
    // загруженные данные
    private let downloadedRealm: Realm
    // данные пользователя
    private let userRealm: Realm
    
    private let filesDirectory: URL
    
    private init() {
        let fileManager = FileManager.default
        
        // создаем дирректорию для приложения в Documents
        let sibsuURL = try! fileManager
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("my-sibsu")
        
        if !fileManager.fileExists(atPath: sibsuURL.path) {
            do {
                try fileManager.createDirectory(at: sibsuURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Не выходит создать папку в Document директории")
            }
        }
        
        let downloadedURL = sibsuURL.appendingPathComponent("my-sibsu-downloaded.realm")
        let userURL = sibsuURL.appendingPathComponent("my-sibsu-user.realm")
        
        var downloadedConfig = Realm.Configuration(fileURL: downloadedURL)
        var userConfig = Realm.Configuration(fileURL: userURL)
        
        // сомнительные МУВЫ
        downloadedConfig.deleteRealmIfMigrationNeeded = true
        userConfig.deleteRealmIfMigrationNeeded = true
        
        print(downloadedURL)
        print(userURL)
        
        downloadedRealm = try! Realm(configuration: downloadedConfig)
        userRealm = try! Realm(configuration: userConfig)
        
        // Создание папки для файлов
        filesDirectory = sibsuURL.appendingPathComponent("files")
        if !fileManager.fileExists(atPath: filesDirectory.path) {
            do {
                try fileManager.createDirectory(at: filesDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Не выходит сосздать папку для файлов")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAll), name: .languageChanged, object: nil)
        
        // deleteTimetable(forGroupId: 1)
        // saveToInitData()
    }
    
    @objc
    private func deleteAll() {
        deleteAllTimetables()
        deleteAllUnions()
        deleteAllBuildings()
        deleteAllInstitutes()
    }
    
//    // MARK: Функция для формирования БД для вставки в приложение в эпстор (нужно закинуть в InitRealm)
//    private func saveToInitData() {
//        do {
//            try downloadedRealm.writeCopy(toFile: URL(string: "/Users/art-off/Desktop/initData.realm")!)
//        } catch let error {
//            print(error)
//        }
//    }
    
}

// MARK: - Getting Entities -
extension DataManager {
    
    // MARK: Groups
    func getGroups() -> [Group] {
        let rGroups = downloadedRealm.objects(RGroup.self)
        let groups = Translator.shared.converteGroups(from: rGroups)
        return groups
    }
    
    func getFavoriteGroups() -> [Group] {
        var groups: [Group] = []
        for id in favoriteGroupsId.reversed() {
            if let rGroup = downloadedRealm.object(ofType: RGroup.self, forPrimaryKey: id) {
                groups.append(Translator.shared.converteGroup(from: rGroup))
            }
        }
        return groups
    }
    
    func getGroup(withId id: Int) -> Group? {
        guard let rGroup = downloadedRealm.object(ofType: RGroup.self, forPrimaryKey: id) else { return nil }
        let group = Translator.shared.converteGroup(from: rGroup)
        return group
    }
    
    // MARK: Professors
    func getProfessors() -> [Professor] {
        let rProfessors = downloadedRealm.objects(RProfessor.self)
        let professors = Translator.shared.converteProfessors(from: rProfessors)
        return professors
    }
    
    func getFavoriteProfessors() -> [Professor] {
        var professors: [Professor] = []
        for id in favoriteProfessorsId.reversed() {
            if let rProfessor = downloadedRealm.object(ofType: RProfessor.self, forPrimaryKey: id) {
                professors.append(Translator.shared.converteProfessor(from: rProfessor))
            }
        }
        return professors
    }
    
    // MARK: Places
    func getPlaces() -> [Place] {
        let rPlaces = downloadedRealm.objects(RPlace.self)
        let places = Translator.shared.convertePlaces(from: rPlaces)
        return places
    }
    
    func getFavoritePlaces() -> [Place] {
        var places: [Place] = []
        for id in favoritePlacesId.reversed() {
            if let rPlace = downloadedRealm.object(ofType: RPlace.self, forPrimaryKey: id) {
                places.append(Translator.shared.convertePlace(from: rPlace))
            }
        }
        return places
    }
    
}

// MARK: - Writing Entities
extension DataManager {
    
    // MARK: Groups
    func write(groups: [RGroup]) {
        let copyGroups = groups.map { $0.newObject() }
        try? downloadedRealm.write {
            downloadedRealm.add(copyGroups, update: .modified)
        }
    }
    
    func write(group: RGroup) {
        let copyGroup = group.newObject()
        try? downloadedRealm.write {
            downloadedRealm.add(copyGroup, update: .modified)
        }
    }
    
    func writeFavorite(groupId: Int) {
        if !favoriteGroupsId.contains(groupId) {
            favoriteGroupsId.append(groupId)
        }
    }
    
    // MARK: Professors
    func write(professor: RProfessor) {
        let copyProfessor = professor.newObject()
        try? downloadedRealm.write {
            downloadedRealm.add(copyProfessor, update: .all)
        }
    }
    
    func write(professors: [RProfessor]) {
        let copyProfessors = professors.map { $0.newObject() }
        try? downloadedRealm.write {
            downloadedRealm.add(copyProfessors, update: .all)
        }
    }
    
    func writeFavorite(professorId: Int) {
        if !favoriteProfessorsId.contains(professorId) {
            favoriteProfessorsId.append(professorId)
        }
    }
    
    // MARK: Places
    func write(place: RPlace) {
        let copyPlace = place.newObject()
        try? downloadedRealm.write {
            downloadedRealm.add(copyPlace, update: .all)
        }
    }
    
    func write(places: [RPlace]) {
        let copyPlaces = places.map { $0.newObject() }
        try? downloadedRealm.write {
            downloadedRealm.add(copyPlaces, update: .all)
        }
    }
    
    func writeFavorite(placeId: Int) {
        if !favoritePlacesId.contains(placeId) {
            favoritePlacesId.append(placeId)
        }
    }

}

// MARK: - Deleting Entities
extension DataManager {
    
    func deleteFavorite(groupId: Int) {
        favoriteGroupsId.delete(elem: groupId)
    }
    
    func deleteFavorite(professorId: Int) {
        favoriteProfessorsId.delete(elem: professorId)
    }
    
    func deleteFavorite(placeId: Int) {
        favoritePlacesId.delete(elem: placeId)
    }
    
}

// MARK: - Getting Timetable
extension DataManager {
    
    func getTimetable(forGroupId id: Int) -> GroupTimetable? {
        guard let rTimetable = userRealm.object(ofType: RGroupTimetable.self, forPrimaryKey: id) else { return nil }
        guard let rGroup = downloadedRealm.object(ofType: RGroup.self, forPrimaryKey: id) else { return nil }
        
        let groupTimetable = Translator.shared.convertGroupTimetable(from: rTimetable, groupName: rGroup.name)
        return groupTimetable
    }
    
    func getTimetable(forProfessorId id: Int) -> ProfessorTimetable? {
        guard let rTimetable = userRealm.object(ofType: RProfessorTimetable.self, forPrimaryKey: id) else { return nil }
        guard let rProfessor = downloadedRealm.object(ofType: RProfessor.self, forPrimaryKey: id) else { return nil }
        
        let professorTimetable = Translator.shared.convertProfessorTimetable(from: rTimetable, professorName: rProfessor.name)
        return professorTimetable
    }
    
    func getTimetable(forPlaceId id: Int) -> PlaceTimetable? {
        guard let rTimetable = userRealm.object(ofType: RPlaceTimetable.self, forPrimaryKey: id) else { return nil }
        guard let rPlace = downloadedRealm.object(ofType: RPlace.self, forPrimaryKey: id) else { return nil }
        
        let placeTimetable = Translator.shared.convertPlaceTimetable(from: rTimetable, placeName: rPlace.name)
        return placeTimetable
    }
    
}

// MARK: - Writing Timetable
extension DataManager {
    
    func write(groupTimetable: RGroupTimetable) {
        try? userRealm.write {
            userRealm.add(groupTimetable, update: .all)
        }
    }
    
    func write(professorTimetable: RProfessorTimetable) {
        try? userRealm.write {
            userRealm.add(professorTimetable, update: .all)
        }
    }
    
    func write(placeTimetable: RPlaceTimetable) {
        try? userRealm.write {
            userRealm.add(placeTimetable, update: .all)
        }
    }
    
}

// MARK: - Deleting Timetable
extension DataManager {
    
    func deleteTimetable(forGroupId groupId: Int) {
        let optionalTimetable = userRealm.object(ofType: RGroupTimetable.self, forPrimaryKey: groupId)
        guard let timetable = optionalTimetable else { return }
        try? userRealm.write {
            userRealm.delete(timetable, cascading: true)
        }
    }
    
    func deleteAllTimetables() {
        let userTimetables = userRealm.objects(RGroupTimetable.self)
        try? userRealm.write {
            userRealm.delete(userTimetables, cascading: true)
        }
        let downloadedTimetables = downloadedRealm.objects(RGroupTimetable.self)
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedTimetables, cascading: true)
        }
    }
    
}

// MARK: - Campus
extension DataManager {
    
    func getInstitutes() -> [RInstitute] {
        let institutes = downloadedRealm.objects(RInstitute.self)
        return Array(institutes)
    }
    
    func getUnions() -> [RUnion] {
        let usions = downloadedRealm.objects(RUnion.self)
        return Array(usions)
    }
    
    func getSportClubs() -> [RSportClub] {
        let sportClubs = downloadedRealm.objects(RSportClub.self)
        return Array(sportClubs)
    }
    
    func getBuildings() -> [RBuilding] {
        let buildings = downloadedRealm.objects(RBuilding.self)
        return Array(buildings)
    }
    
    func getDesingOffice() -> [RDesingOffice] {
        let desingOffice = downloadedRealm.objects(RDesingOffice.self)
        return Array(desingOffice)
    }
    
    func write(institutes: [RInstitute]) {
        try? downloadedRealm.write {
            downloadedRealm.add(institutes, update: .all)
        }
    }
    
    func write(institute: RInstitute) {
        try? downloadedRealm.write {
            downloadedRealm.add(institute, update: .all)
        }
    }
    
    func write(unions: [RUnion]) {
        try? downloadedRealm.write {
            downloadedRealm.add(unions, update: .all)
        }
    }
    
    func write(union: RInstitute) {
        try? downloadedRealm.write {
            downloadedRealm.add(union, update: .all)
        }
    }
    
    func write(buildings: [RBuilding]) {
        try? downloadedRealm.write {
            downloadedRealm.add(buildings, update: .all)
        }
    }
    
    func write(building: RBuilding) {
        try? downloadedRealm.write {
            downloadedRealm.add(building, update: .all)
        }
    }
    
    func write(sportClubs: [RSportClub]) {
        try? downloadedRealm.write {
            downloadedRealm.add(sportClubs, update: .all)
        }
    }
    
    func write(desingOffices: [RDesingOffice]) {
        try? downloadedRealm.write {
            downloadedRealm.add(desingOffices, update: .all)
        }
    }
    
    func delete(institutes: [RInstitute]) {
        try? downloadedRealm.write {
            downloadedRealm.delete(institutes, cascading: true)
        }
    }
    
    func delete(institute: RInstitute) {
        try? downloadedRealm.write {
            downloadedRealm.delete(institute, cascading: true)
        }
    }
    
    func delete(unions: [RUnion]) {
        try? downloadedRealm.write {
            downloadedRealm.delete(unions, cascading: true)
        }
    }
    
    func delete(union: RInstitute) {
        try? downloadedRealm.write {
            downloadedRealm.delete(union, cascading: true)
        }
    }
    
    func delete(buildings: [RBuilding]) {
        try? downloadedRealm.write {
            downloadedRealm.delete(buildings, cascading: true)
        }
    }
    
    func delete(building: RBuilding) {
        try? downloadedRealm.write {
            downloadedRealm.delete(building, cascading: true)
        }
    }
    
    func deleteAllInstitutes() {
        let userInstitutes = userRealm.objects(RInstitute.self)
        try? userRealm.write {
            userRealm.delete(userInstitutes, cascading: true)
        }
        let downloadedInstitutes = downloadedRealm.objects(RInstitute.self)
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedInstitutes, cascading: true)
        }
    }
    
    func deleteAllUnions() {
        let userUnions = userRealm.objects(RUnion.self)
        try? userRealm.write {
            userRealm.delete(userUnions, cascading: true)
        }
        let downloadedUnions = downloadedRealm.objects(RUnion.self)
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedUnions, cascading: true)
        }
    }
    
    func deleteAllBuildings() {
        let userBuildings = userRealm.objects(RBuilding.self)
        try? userRealm.write {
            userRealm.delete(userBuildings, cascading: true)
        }
        let downloadedBuildings = downloadedRealm.objects(RBuilding.self)
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedBuildings, cascading: true)
        }
    }
    
    func deleteAllSportClubs() {
        let userSportClubs = userRealm.objects(RSportClub.self)
        try? userRealm.write {
            userRealm.delete(userSportClubs, cascading: true)
        }
        let downloadedSportClubs = downloadedRealm.objects(RSportClub.self)
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedSportClubs, cascading: true)
        }
    }
    
    func deleteAllDesingOffices() {
        let userDesingOffices = userRealm.objects(RDesingOffice.self)
        try? userRealm.write {
            userRealm.delete(userDesingOffices, cascading: true)
        }
        let downloadedDesingOffices = downloadedRealm.objects(RDesingOffice.self)
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedDesingOffices, cascading: true)
        }
    }
    
}


extension DataManager {
    
    var filesDirectoryUrl: URL {
        return filesDirectory
    }
    
}
