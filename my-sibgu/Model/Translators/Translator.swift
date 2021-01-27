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
        1: SubgroupType.lecrute,
        2: SubgroupType.laboratoryWork,
        3: SubgroupType.practice,
    ]
    
    // MARK: Перевод объекта РАСПИСАНИЯ ГРУППЫ Realm к структуре, используемой в приложении
    func convertGroupTimetable(from timetable: RGroupTimetable, groupName: String) -> GroupTimetable {
        let groupTimetable = GroupTimetable(
            groupName: groupName,
            groupId: timetable.objectId,
            weeks: converteWeeks(from: timetable.weeks)
        )
        return groupTimetable
    }
    
    func convertProfessorTimetable(from timetable: RProfessorTimetable, professorName: String) -> ProfessorTimetable {
        let professorTimetable = ProfessorTimetable(
            professorName: professorName,
            professorId: timetable.objectId,
            weeks: converteWeeks(from: timetable.weeks)
        )
        return professorTimetable
    }
    
    func convertPlaceTimetable(from timetable: RPlaceTimetable, placeName: String) -> PlaceTimetable {
        let placeTimetable = PlaceTimetable(
            placeName: placeName,
            placeId: timetable.objectId,
            weeks: converteWeeks(from: timetable.weeks)
        )
        return placeTimetable
    }
    
    private func converteWeeks(from rWeeks: List<RWeek>) -> [Week] {
        var weeks = [Week]()
        
        // пробегаемся по всем неделям (по дву)
        for rWeek in rWeeks {

            // заполняем массив дней nil, потом если будут учебные дни в этой недели - заменю значение
            var groupDays: [Day?] = [nil, nil, nil, nil, nil, nil]

            // пробегаемся во всем дням недели
            for rDay in rWeek.days {

                var groupLessons = [Lesson]()
                
                // пробегаемся по всем занятиям дня
                for rLesson in rDay.lessons {

                    var subgroups = [Subgroup]()
                    
                    // пробегаемся по всех подргуппам занятия
                    for rSubgroup in rLesson.subgroups {
                        let subgroup = Subgroup(
                            number: rSubgroup.number,
                            subject: rSubgroup.subject,
                            type: subgroupType[rSubgroup.type] ?? .undefined,
                            group: rSubgroup.group,
                            professor: rSubgroup.professor,
                            place: rSubgroup.place,
                            groupId: rSubgroup.groupId,
                            professorId: rSubgroup.professorId,
                            placeId: rSubgroup.placeId
                        )

                        subgroups.append(subgroup)
                    }
                    
                    // добавляем занятие в массив занятий
                    let groupLesson = Lesson(
                        // Если получается преобразовать время, иначе вставляем такое как есть
                        time: converte(time: rLesson.time) ?? rLesson.time,
                        subgroups: subgroups
                    )
                    
                    groupLessons.append(groupLesson)
                }
                
                let day = Day(lessons: groupLessons)
                // проверяем, подходит ли number для вставки в массив groupDays (0-понедельник, 5-суббота)
                if rDay.number >= 0 && rDay.number <= 5 {
                    // заменяем nil
                    groupDays[rDay.number] = day
                }
            }

            let groupWeek = Week(days: groupDays)
            weeks.append(groupWeek)
        }
        
        return weeks
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
            let group = Group(id: rGroup.id, name: rGroup.name)
            groups.append(group)
        }
        
        return groups
    }
    
    func converteGroup(from rGroup: RGroup) -> Group {
        return Group(id: rGroup.id, name: rGroup.name)
    }
    
    func converteBuildings(from rBuildings: [RBuilding]) -> [Building] {
        var builginds = [Building]()
        rBuildings.forEach { rBuilding in
            let building = Building(
                id: rBuilding.id,
                name: rBuilding.name,
                type: rBuilding.type,
                address: rBuilding.address,
                coast: rBuilding.coast == 0 ? .left : .right,
                urlTo2gis: URL(string: rBuilding.urlTo2gis
                                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
            builginds.append(building)
        }
        
        return builginds
    }
    
    func converteInstitutes(from rInstitutes: [RInstitute]) -> [Institute] {
        var institutes = [Institute]()
        rInstitutes.forEach { rInstitute in
            let institute = Institute(
                name: rInstitute.name,
                shortName: rInstitute.shortName,
                director: converteDirector(from: rInstitute.director),
                departments: converteDepartments(from: rInstitute.departments),
                soviet: converteSoviet(from: rInstitute.soviet)
            )
            institutes.append(institute)
        }
        return institutes
    }
    
    private func converteDirector(from rDirector: RDirector?) -> Institute.Director? {
        guard let rDirector = rDirector else { return nil }
        let director = Institute.Director(
            name: rDirector.name,
            imageUrl: ApiUniversityInfo.download(with: rDirector.imageUrl),
            address: rDirector.address,
            phone: rDirector.phone,
            email: rDirector.email
        )
        return director
    }
    
    private func converteDepartments(from rDepartments: List<RDepartment>) -> [Institute.Department] {
        var departments = [Institute.Department]()
        rDepartments.forEach { rDepartment in
            let department = Institute.Department(
                name: rDepartment.name,
                leaderName: rDepartment.leaderName,
                address: rDepartment.address,
                phone: rDepartment.phone,
                email: rDepartment.email
            )
            departments.append(department)
        }
        return departments
    }
    
    private func converteSoviet(from rSoviet: RSoviet?) -> Institute.Soviet? {
        guard let rSoviet = rSoviet else { return nil }
        let soviet = Institute.Soviet(
            imageUrl: ApiUniversityInfo.download(with: rSoviet.imageUrl),
            leaderName: rSoviet.leaderName,
            address: rSoviet.address,
            phone: rSoviet.phone,
            email: rSoviet.email
        )
        return soviet
    }
    
    func converteUnions(from rUnions: [RUnion]) -> [Union] {
        var unions = [Union]()
        rUnions.forEach { rUnion in
            let union = Union(
                id: rUnion.id,
                name: rUnion.name,
                shortName: rUnion.shortName,
                leaderRank: rUnion.leaderRank,
                leaderName: rUnion.leaderName,
                address: rUnion.address,
                phone: rUnion.phone,
                groupVkUrl: URL(string: rUnion.groupVkUrl)!,
                leaderPageVkUrl: rUnion.leaderPageVkUrl != nil ? URL(string: rUnion.leaderPageVkUrl!) : nil,
                about: rUnion.about,
                rank: rUnion.rank,
                logoUrl: ApiUniversityInfo.download(with: rUnion.logoUrl),
                leaderPhotoUrl: ApiUniversityInfo.download(with: rUnion.leaderPhotoUrl)
            )
            unions.append(union)
        }
        return unions
    }
    
}
