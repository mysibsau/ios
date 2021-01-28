//
//  TimetableViewModelTranslator.swift
//  my-sibgu
//
//  Created by art-off on 28.01.2021.
//

import Foundation

class TimetableViewModelTranslator {
    
    static func groupTimetableToViewModel(groupTimetable: GroupTimetable) -> TimetableViewModel {
        let timetableViewModel = TimetableViewModel(
            objectName: groupTimetable.groupName,
            weeks: weeksTo(.group, weeks: groupTimetable.weeks)
        )
        return timetableViewModel
    }
    
    static func professorTimetableToViewModel(professorTimetable: ProfessorTimetable) -> TimetableViewModel {
        let timetableViewModel = TimetableViewModel(
            objectName: professorTimetable.professorName,
            weeks: weeksTo(.professor, weeks: professorTimetable.weeks)
        )
        return timetableViewModel
    }
    
    static func placeTimetableToViewModel(placeTimetable: PlaceTimetable) -> TimetableViewModel {
        let timetableViewModel = TimetableViewModel(
            objectName: placeTimetable.placeName,
            weeks: weeksTo(.professor, weeks: placeTimetable.weeks)
        )
        return timetableViewModel
    }
    
    static private func weeksTo(_ type: EntitiesType, weeks: [Week]) -> [WeekViewModel] {
        var weekViewModels: [WeekViewModel] = []
        
        for week in weeks {
            var dayViewModels: [DayViewModel?] = []
            
            for day in week.days {
                if let day = day {
                    var lessonViewModels: [LessonViewModel] = []
                    
                    for lesson in day.lessons {
                        var subgroupViewModels: [SubgroupViewModel] = []
                        
                        for subgroup in lesson.subgroups {
                            let addInfo1: String
                            let addInfo2: String
                            switch type {
                            case .group:
                                addInfo1 = subgroup.professor
                                addInfo2 = subgroup.place
                            case .professor:
                                addInfo1 = subgroup.group
                                addInfo2 = subgroup.place
                            case .place:
                                addInfo1 = subgroup.professor
                                addInfo2 = subgroup.group
                            }
                            
                            let subgroupViewModel = SubgroupViewModel(
                                number: subgroup.number,
                                subject: subgroup.subject.capitalizinFirstLetter(),
                                type: subgroup.type,
                                addInfo1: addInfo1,
                                addInfo2: addInfo2,
                                addTimetableType: nil,
                                addTimetableId: nil
                            )
                            subgroupViewModels.append(subgroupViewModel)
                        }
                        
                        let lessonViewModel = LessonViewModel(
                            time: lesson.time,
                            subgroups: subgroupViewModels
                        )
                        lessonViewModels.append(lessonViewModel)
                    }
                    
                    let dayViewModel = DayViewModel(lessons: lessonViewModels)
                    dayViewModels.append(dayViewModel)
                } else {
                    dayViewModels.append(nil)
                }
            }
            let weekViewModel = WeekViewModel(days: dayViewModels)
            weekViewModels.append(weekViewModel)
        }
        
        return weekViewModels
    }
    
}
