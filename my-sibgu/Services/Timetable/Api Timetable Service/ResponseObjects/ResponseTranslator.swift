//
//  ResponseTranslator.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class ResponseTranslator {
    
    static func converteGroupTimetableResponseToRGroupTimetable(groupTimetableResponse: TimetableResponse, groupId: Int) -> RGroupTimetable {
        let groupTimetable = RGroupTimetable()
        groupTimetable.objectId = groupId
        
        let groupOddWeek = converteGroupDaysResponseToRGroupWeek(groupDaysResponse: groupTimetableResponse.oddWeek)
        let groupEvenWeek = converteGroupDaysResponseToRGroupWeek(groupDaysResponse: groupTimetableResponse.evenWeek)
        groupTimetable.weeks.append(groupOddWeek)
        groupTimetable.weeks.append(groupEvenWeek)
        
        return groupTimetable
    }
    
    private static func converteGroupDaysResponseToRGroupWeek(groupDaysResponse: [DayResponse]) -> RWeek {
        let groupWeek = RWeek()
        
        for groupDayResponse in groupDaysResponse {
            let groupDay = RDay()
            
            groupDay.number = groupDayResponse.number
            
            for groupLessonResponse in groupDayResponse.lessons {
                let groupLesson = RLesson()
                
                groupLesson.time = groupLessonResponse.time
                
                for groupSubgroupResponse in groupLessonResponse.subgroups {
                    let groupSubgroup = RSubgroup()
                    groupSubgroup.number = groupSubgroupResponse.number
                    groupSubgroup.subject = groupSubgroupResponse.subject
                    groupSubgroup.professor = groupSubgroupResponse.professor
                    groupSubgroup.place = groupSubgroupResponse.place
                    groupSubgroup.type = groupSubgroupResponse.type
                    
                    groupLesson.subgroups.append(groupSubgroup)
                }
                
                groupDay.lessons.append(groupLesson)
            }
            
            // Если в этот день есть пары - добавляем
            if !groupDay.lessons.isEmpty {
                groupWeek.days.append(groupDay)
            }
        }
        
        return groupWeek
    }
    
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
