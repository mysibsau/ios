//
//  DatabaseManager.swift
//  my-sibgu
//
//  Created by Artem Rylov on 11.08.2021.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let realm: Realm
    
    private init() {
        let sibsuURL = Self.createAppDirectoryIdNeeded()
        
        var realmConfig = Realm.Configuration(fileURL: sibsuURL.appendingPathComponent("my-sibsu.realm"))
        realmConfig.deleteRealmIfMigrationNeeded = true
        
        realm = try! Realm(configuration: realmConfig)
        
        print(realm.configuration.fileURL as Any)
    }
    
    // MARK: - CURD without Update (Update == Write)
    func get<T: Object>(_ type: T.Type) -> [T] {
        Array(realm.objects(type))
    }
    
    func write<T: Object>(_ object: T) {
        try? realm.write {
            realm.add(object, update: .all)
        }
    }
    
    func write<T: Object>(_ objects: [T]) {
        try? realm.write {
            realm.add(objects, update: .all)
        }
    }
    
    func deleteAll<T: Object>(_ type: T.Type) {
        try? realm.write {
            realm.delete(realm.objects(T.self), cascading: true)
        }
    }
}


// MARK: - Helper
extension DatabaseManager {
    
    static private func createAppDirectoryIdNeeded() -> URL {
        let fileManager = FileManager.default
        
        let sibsuURL = try! fileManager
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("my-sibsu")
        
        if !fileManager.fileExists(atPath: sibsuURL.path) {
            do {
                try fileManager.createDirectory(at: sibsuURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                NSLog("Не выходит создать папку в Document директории")
            }
        }
        
        return sibsuURL
    }
}
