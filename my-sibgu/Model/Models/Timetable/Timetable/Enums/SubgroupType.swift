//
//  SubgroupType.swift
//  my-sibgu
//
//  Created by art-off on 30.11.2020.
//

import Foundation

enum SubgroupType: String {
    
    case lecrute = "Лекция"
    case practice = "Практика"
    case laboratoryWork = "Лабораторная работа"
    case undefined = "Неопознанный"
    
    var localized: String {
        let tableName = "Timetable"
        
        switch self {
        case .lecrute: return "lecture".localized(using: tableName)
        case .practice: return "practice".localized(using: tableName)
        case .laboratoryWork: return "laboratoryWork".localized(using: tableName)
        case .undefined: return "undefined".localized(using: tableName)
        }
    }
    
}
