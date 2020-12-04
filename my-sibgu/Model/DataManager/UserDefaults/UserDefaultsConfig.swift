//
//  UserDefaultsConfig.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

struct UserDefaultsConfig {
    
    @UserDefaultsWrapper(key: "com.my-sibsu.user.timetableType", defaultValue: String?(nil))
    static var timetableType: String?

    @UserDefaultsWrapper(key: "com.my-sibsu.user.timetableId", defaultValue: Int?(nil))
    static var timetableId: Int?
    
    @UserDefaultsWrapper(key: "com.my-sibsu.system.firstWeekIsEven", defaultValue: true)
    static var firstWeekIsEven: Bool
    
    // MARK: Hash для определения версии таблиц
    @UserDefaultsWrapper(key: "com.my-sibsu.system.groupsHash", defaultValue: String?(nil))
    static var groupsHash: String?
    
}
