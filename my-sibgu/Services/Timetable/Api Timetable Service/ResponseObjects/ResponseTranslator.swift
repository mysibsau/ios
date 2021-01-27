//
//  ResponseTranslator.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class ResponseTranslator {
    
    // MARK: - Timetables
    static func converteTimetableResponseToRGroupTimetable(timetableResponse: TimetableResponse, groupId: Int) -> RGroupTimetable {
        let groupTimetable = RGroupTimetable()
        groupTimetable.objectId = groupId
        
        let groupOddWeek = converteDaysResponseToRWeek(daysResponse: timetableResponse.oddWeek)
        let groupEvenWeek = converteDaysResponseToRWeek(daysResponse: timetableResponse.evenWeek)
        groupTimetable.weeks.append(groupOddWeek)
        groupTimetable.weeks.append(groupEvenWeek)
        
        return groupTimetable
    }
    
    static func converteTimetableResponseToProfessorTimetable(timetableResponse: TimetableResponse, professorId: Int) -> RProfessorTimetable {
        let professorTimetable = RProfessorTimetable()
        professorTimetable.objectId = professorId
        
        let professorOddWeek = converteDaysResponseToRWeek(daysResponse: timetableResponse.oddWeek)
        let professorEvenWeek = converteDaysResponseToRWeek(daysResponse: timetableResponse.evenWeek)
        professorTimetable.weeks.append(professorOddWeek)
        professorTimetable.weeks.append(professorEvenWeek)
        
        return professorTimetable
    }
    
    private static func converteDaysResponseToRWeek(daysResponse: [DayResponse]) -> RWeek {
        let week = RWeek()
        
        for dayResponse in daysResponse {
            let day = RDay()
            
            day.number = dayResponse.number
            
            for lessonResponse in dayResponse.lessons {
                let lesson = RLesson()
                
                lesson.time = lessonResponse.time
                
                for subgroupResponse in lessonResponse.subgroups {
                    let subgroup = RSubgroup()
                    subgroup.number = subgroupResponse.number
                    subgroup.subject = subgroupResponse.subject
                    subgroup.type = subgroupResponse.type
                    
                    subgroup.group = subgroupResponse.group
                    subgroup.professor = subgroupResponse.professor
                    subgroup.place = subgroupResponse.place
                    
                    subgroup.groupId = subgroupResponse.groupId
                    subgroup.professorId = subgroupResponse.professorId
                    subgroup.placeId = subgroupResponse.placeId
                    
                    lesson.subgroups.append(subgroup)
                }
                
                day.lessons.append(lesson)
            }
            
            // Если в этот день есть пары - добавляем
            if !day.lessons.isEmpty {
                week.days.append(day)
            }
        }
        
        return week
    }
    
    
    // MARK: - Entities
    static func converteGroupResponseToRGroup(groupsResponse: [GroupResponse]) -> [RGroup] {
        var rGroups = [RGroup]()
        
        for groupResponse in groupsResponse {
            let rGroup = RGroup()
            rGroup.id = groupResponse.id
            rGroup.name = groupResponse.name
            
            rGroups.append(rGroup)
        }
        
        return rGroups
    }
    
    static func converteProfessorResponseToRProfessor(professorsResponse: [ProfessorResponse]) -> [RProfessor] {
        var rProfessors = [RProfessor]()
        
        for professorResponse in professorsResponse {
            let rProfessor = RProfessor()
            rProfessor.id = professorResponse.id
            rProfessor.name = professorResponse.name
            rProfessor.idPallada = professorResponse.idPallada
            
            rProfessors.append(rProfessor)
        }
        
        return rProfessors
    }
    
    static func convertePlaceResponseToRPlace(placesResponse: [PlaceResponse]) -> [RPlace] {
        var rPlaces = [RPlace]()
        
        for placeResponse in placesResponse {
            let rPlace = RPlace()
            rPlace.id = placeResponse.id
            rPlace.name = placeResponse.name
            rPlace.address = placeResponse.address
            
            rPlaces.append(rPlace)
        }
        
        return rPlaces
    }
    
}
