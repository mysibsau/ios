//
//  Translator.swift
//  my-sibgu
//
//  Created by art-off on 12.11.2020.
//

import Foundation
import RealmSwift

class Translator {
    
    static let shared = Translator()
    
    private let subgroupType = [
        1: "(Лекция)",
        2: "(Лабораторная работа)",
        3: "(Практика)",
    ]
    
    // MARK: Перевод объекта РАСПИСАНИЯ ГРУППЫ Realm к структуре, используемой в приложении
    func convertGroupTimetable(from timetable: RGroupTimetable, groupName: String) -> GroupTimetable {
        var groupWeeks = [GroupWeek]()

        // пробегаемся по всем неделям (по дву)
        for week in timetable.weeks {

            // заполняем массив дней nil, потом если будут учебные дни в этой недели - заменю значение
            var groupDays: [GroupDay?] = [nil, nil, nil, nil, nil, nil]

            // пробегаемся во всем дням недели
            for day in week.days {

                var groupLessons = [GroupLesson]()
                
                // пробегаемся по всем занятиям дня
                for lesson in day.lessons {

                    var groupSubgroups = [GroupSubgroup]()
                    
                    // пробегаемся по всех подргуппам занятия
                    for subgroup in lesson.subgroups {
                        let groupSubgroup = GroupSubgroup(
                            number: subgroup.number,
                            subject: subgroup.subject.capitalizinFirstLetter(),
                            type: subgroupType[subgroup.type] ?? "(Неопознанный)",
                            professor: subgroup.professor,
                            place: subgroup.place)

                        groupSubgroups.append(groupSubgroup)
                    }
                    
                    // добавляем занятие в массив занятий
                    let groupLesson = GroupLesson(
                        // Если получается преобразовать время, иначе вставляем такое как есть
                        time: converte(time: lesson.time) ?? lesson.time,
                        subgroups: groupSubgroups)
                    
                    groupLessons.append(groupLesson)
                }
                
                let groupDay = GroupDay(lessons: groupLessons)
                // проверяем, подходит ли number для вставки в массив groupDays (0-понедельник, 5-суббота)
                if day.number >= 0 && day.number <= 5 {
                    // заменяем nil
                    groupDays[day.number] = groupDay
                }
            }

            let groupWeek = GroupWeek(days: groupDays)
            groupWeeks.append(groupWeek)
        }

        let groupTimetable = GroupTimetable(groupId: timetable.groupId, groupName: groupName, weeks: groupWeeks)
        return groupTimetable
    }
    
    private func converte(time: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: #"\d\d.\d\d"#) else { return nil }
        
        let range = NSRange(location: 0, length: time.utf16.count)
        let matches = regex.matches(in: time, options: [], range: range)
        
        // Если нет ни одного совпадения
        guard !matches.isEmpty else { return nil }
        
        var times = [String]()
        
        for match in matches {
            times.append((time as NSString).substring(with: match.range))
        }
        
        // Если совпадений не 2 (должен быть только начало и конец)
        guard times.count == 2 else { return nil }
        
        return "\(times[0]) - \(times[1])"
    }
    
    func converteGroups(from rGroups: Results<RGroup>) -> [Group] {
        var groups = [Group]()
        rGroups.forEach { rGroup in
            let group = Group(id: rGroup.id, name: rGroup.name, email: rGroup.email)
            groups.append(group)
        }
        
        return groups
    }
    
    func converteGroup(from rGroup: RGroup) -> Group {
        return Group(id: rGroup.id, name: rGroup.name, email: rGroup.email)
    }
    
}
