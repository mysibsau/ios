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

// MARK: - Getting Entities
extension DataManager {
    
    func getGroups() -> [Group] {
        let rGroups = downloadedRealm.objects(RGroup.self)
        let groups = Translator.shared.converteGroups(from: rGroups)
        return groups
    }
    
    func getFavoriteGruops() -> [Group] {
        let rGroups = userRealm.objects(RGroup.self)
        let groups = Translator.shared.converteGroups(from: rGroups)
        return groups
    }
    
    func getGroup(withId id: Int) -> Group? {
        guard let rGroup = downloadedRealm.object(ofType: RGroup.self, forPrimaryKey: id) else { return nil }
        let group = Translator.shared.converteGroup(from: rGroup)
        return group
    }
    
}

// MARK: - Writing Entities
extension DataManager {
    
    func writeFavorite(groups: [RGroup]) {
        // Если эти объекты уже будут в одном из хранилищь - так мы обезопасим себя от ошибки
        let copyGroups = groups.map { $0.newObject() }
        try? userRealm.write {
            userRealm.add(copyGroups, update: .modified)
        }
    }
    
    func writeFavorite(group: RGroup) {
        let copyGroup = group.newObject()
        try? userRealm.write {
            userRealm.add(copyGroup, update: .modified)
        }
    }
    
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

}

// MARK: - Deleting Entities
extension DataManager {
    
    func deleteFavorite(groups: [RGroup]) {
        try? userRealm.write {
            userRealm.delete(groups, cascading: true)
        }
    }
    
    func deleteFavorite(group: RGroup) {
        try? userRealm.write {
            userRealm.delete(group, cascading: true)
        }
    }
    
    func delete(groups: [RGroup]) {
        try? userRealm.write {
            userRealm.delete(groups, cascading: true)
        }
    }
    
    func delete(group: RGroup) {
        try? userRealm.write {
            userRealm.delete(group, cascading: true)
        }
    }
    
}

// MARK: - Getting Timetable
extension DataManager {
    
    func getTimetable(forGroupId groupId: Int) -> GroupTimetable? {
        let optionalTimetable = userRealm.object(ofType: RGroupTimetable.self, forPrimaryKey: groupId)
        let optionalGroup = downloadedRealm.object(ofType: RGroup.self, forPrimaryKey: groupId)
        guard let timetable = optionalTimetable else { return nil }
        guard let group = optionalGroup else { return nil }
        
        let groupTimetable = Translator.shared.convertGroupTimetable(from: timetable, groupName: group.name)
        
        return groupTimetable
    }
    
}

// MARK: - Writing Timetable
extension DataManager {
    
    func write(groupTimetable: RGroupTimetable) {
        try? userRealm.write {
            userRealm.add(groupTimetable, update: .all)
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
    
    func getBuildings() -> [RBuilding] {
        let buildings = downloadedRealm.objects(RBuilding.self)
        return Array(buildings)
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
    
}


extension DataManager {
    
    var filesDirectoryUrl: URL {
        return filesDirectory
    }
    
}
