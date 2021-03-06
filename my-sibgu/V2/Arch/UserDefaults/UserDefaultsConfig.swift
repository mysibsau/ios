//
//  UserDefaultsConfig.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

struct UserDefaultsConfig {
    
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.user.timetableType", defaultValue: Int?(nil))
    static var timetableType: Int?

    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.user.timetableId", defaultValue: Int?(nil))
    static var timetableId: Int?
    
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.system.firstWeekIsEven", defaultValue: false)
    static var firstWeekIsEven: Bool
    
    // MARK: Hash для определения версии таблиц
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.system.groupsHash", defaultValue: String?(nil))
    static var groupsHash: String?
    
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.system.professorsHash", defaultValue: String?(nil))
    static var professorsHash: String?
    
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.system.placesHash", defaultValue: String?(nil))
    static var placesHash: String?
    
    // MARK: UUID для API
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.system.uuidForApi", defaultValue: String?(nil))
    static var uuidForApi: String?
    
    // MARK: Для первой авторизации
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.system.isFirstLaunchV2", defaultValue: true)
    static var isFirstLaunch: Bool
    
    // MARK: User
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.user.studentId", defaultValue: String?(nil))
    static var userStudentId: String?
    
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.user.password", defaultValue: String?(nil))
    static var userPassword: String?
    
    // MARK: Cafeteria
    @UserDefaultsWrapper(key: "com.SibSU.MySibSU.user.cafeteria", defaultValue: String?(nil))
    static var cafeteria: String?
    
}
