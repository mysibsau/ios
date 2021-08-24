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

    @UserDefaultsWrapper(key: "favorite-ids", defaultValue: Data())
    private var favoriteIdsData: Data
    
    @UserDefaultsWrapper(key: "last-books", defaultValue: Data())
    private var lastBooks: Data
    
    
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
        
        // saveToInitData()
    }
    
    @objc
    private func deleteAll() {
        deleteAllTimetables()
        deleteAllUnions()
        deleteAllBuildings()
        deleteAllInstitutes()
        deleteAllSportClubs()
        deleteAllDesingOffices()
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
    
    // MARK: Places
    func getPlaces() -> [Place] {
        let rPlaces = downloadedRealm.objects(RPlace.self)
        let places = Translator.shared.convertePlaces(from: rPlaces)
        return places
    }
    
}


// MARK: - Favorites
extension DataManager {
    
    func getFavorites() -> [TimetableEntity] {
        var result: [TimetableEntity] = []
        
        let favorites = getFavoritesSaved()
        
        for favorite in favorites {
            switch favorite.type {
            case .group:
                if let rGroup = downloadedRealm.object(ofType: RGroup.self, forPrimaryKey: favorite.id) {
                    let group = Translator.shared.converteGroup(from: rGroup)
                    result.append(.group(group))
                }
            case .professor:
                if let rProfessor = downloadedRealm.object(ofType: RProfessor.self, forPrimaryKey: favorite.id) {
                    let professor = Translator.shared.converteProfessor(from: rProfessor)
                    result.append(.professor(professor))
                }
            case .place:
                if let rPlace = downloadedRealm.object(ofType: RPlace.self, forPrimaryKey: favorite.id) {
                    let place = Translator.shared.convertePlace(from: rPlace)
                    result.append(.place(place))
                }
            }
        }
        
        return result
    }
    
    func writeFavorite(entity: SavedEntity) {
        var favorites = getFavoritesSaved()
        
        if !favorites.contains(where: { $0.type == entity.type && $0.id == entity.id }) {
            favorites.append(entity)
            if let newFavorites = try? JSONEncoder().encode(favorites) {
                favoriteIdsData = newFavorites
            }
        }
    }
    
    func deleteFavorite(entity: SavedEntity) {
        var favorites = getFavoritesSaved()
        
        favorites.removeAll(where: { $0.type == entity.type && $0.id == entity.id })
        
        if let newFavorites = try? JSONEncoder().encode(favorites) {
            favoriteIdsData = newFavorites
        }
    }
    
    private func getFavoritesSaved() -> [SavedEntity] {
        return (try? JSONDecoder().decode([SavedEntity].self, from: favoriteIdsData)) ?? []
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

}

// MARK: - Deleting Entities
extension DataManager {
    
    func deleteAllGroups() {
        let userGroups = userRealm.objects(RGroup.self)
        try? userRealm.write {
            userRealm.delete(userGroups, cascading: true)
        }
        let downloadedGroups = downloadedRealm.objects(RGroup.self)
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedGroups, cascading: true)
        }
        favoriteIdsData = Data()
    }
    
    func deleteAllProfessors() {
        let userProfessors = userRealm.objects(RProfessor.self)
        try? userRealm.write {
            userRealm.delete(userProfessors, cascading: true)
        }
        let downloadedProfessors = downloadedRealm.objects(RProfessor.self)
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedProfessors, cascading: true)
        }
        favoriteIdsData = Data()
    }
    
    func deleteAllPlaces() {
        let userPlaces = userRealm.objects(RPlace.self)
        try? userRealm.write {
            userRealm.delete(userPlaces, cascading: true)
        }
        let downloadedPlaces = downloadedRealm.objects(RPlace.self)
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedPlaces, cascading: true)
        }
        favoriteIdsData = Data()
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
    
    func get<T: Object>(_ type: T.Type) -> [T] {
        Array(downloadedRealm.objects(T.self))
    }
    
    func write<T: Object>(object: T) {
        try? downloadedRealm.write {
            downloadedRealm.add(object, update: .all)
        }
    }
    
    func write<T: Object>(objects: [T]) {
        try? downloadedRealm.write {
            downloadedRealm.add(objects, update: .all)
        }
    }
    
    func deleteAll<T: Object>(_ type: T.Type) {
        try? userRealm.write {
            userRealm.delete(userRealm.objects(T.self), cascading: true)
        }
        try? downloadedRealm.write {
            downloadedRealm.delete(downloadedRealm.objects(T.self), cascading: true)
        }
    }
}

// MARK: - Auth
extension DataManager {
    
    func replaceCurrUser(on user: RUser?) {
        let rUsers = userRealm.objects(RUser.self)
        try? userRealm.write {
            userRealm.delete(rUsers, cascading: true)
        }
        
        if let user = user {
            try? userRealm.write {
                userRealm.add(user, update: .all)
            }
        }
    }
    
    func getCurrUser() -> User? {
        guard let rUser = userRealm.objects(RUser.self).first else { return nil }
        return Translator.shared.converteUser(from: rUser)
    }
    
}


// MARK: - Library
extension DataManager {
    
    func getLastBooks() -> [DigitalBook] {
        return (try? JSONDecoder().decode([DigitalBook].self, from: lastBooks)) ?? []
    }
    
    func writeLastBook(newBook: DigitalBook) {
        var books = getLastBooks()
        
        books.removeAll(where: { $0.name == newBook.name && $0.author == newBook.author })
        books.append(newBook)
        
        if books.count > 10 {
            books.removeFirst()
        }
        if let newBooks = try? JSONEncoder().encode(books) {
            lastBooks = newBooks
        }
    }
    
}


extension DataManager {
    
    var filesDirectoryUrl: URL {
        return filesDirectory
    }
    
}
