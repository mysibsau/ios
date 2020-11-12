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
    
    init() {
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
        
        // deleteTimetable(forGroupId: 1)
        // saveToInitData()
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
    
    func getGroups() -> Results<RGroup> {
        let groups = downloadedRealm.objects(RGroup.self)
        return groups
    }
    
    func getFavoriteGruops() -> Results<RGroup> {
        let groups = userRealm.objects(RGroup.self)
        return groups
    }
    
    func getGroup(withId id: Int) -> RGroup? {
        let group = downloadedRealm.object(ofType: RGroup.self, forPrimaryKey: 1)
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
    
}
