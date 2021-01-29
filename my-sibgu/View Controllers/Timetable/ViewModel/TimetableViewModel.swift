//
//  TimetableViewModel.swift
//  my-sibgu
//
//  Created by art-off on 28.01.2021.
//

import Foundation

struct TimetableViewModel {
    
    let objectName: String
    let weeks: [WeekViewModel]
    
}

struct WeekViewModel {
    let days: [DayViewModel?]
}

struct DayViewModel {
    let lessons: [LessonViewModel]
}

struct LessonViewModel {
    let time: String
    let subgroups: [SubgroupViewModel]
}

struct SubgroupViewModel {
    let number: Int
    let subject: String
    let type: SubgroupType
    let addInfo1: String
    let addInfo2: String
    
    // Поля для того, чтобы открывать расписание
    // - преподов, когда смотришь группы
    // - группы, когда смотришь преподов
    // и т. д.
    let addTimetableType: EntitiesType?
    let addTimetableId: Int?
}
