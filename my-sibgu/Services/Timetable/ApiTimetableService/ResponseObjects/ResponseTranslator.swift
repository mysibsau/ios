//
//  ResponseTranslator.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class ResponseTranslator {
    
    static func converteGroupTimetableResponseToRGroupTimetable(groupTimetableResponse: GroupTimetableResponse, groupId: Int) -> RGroupTimetable {
        let groupTimetable = RGroupTimetable()
        groupTimetable.groupId = groupId
        
        let groupOddWeek = converteGroupDaysResponseToRGroupWeek(groupDaysResponse: groupTimetableResponse.oddWeek)
        let groupEvenWeek = converteGroupDaysResponseToRGroupWeek(groupDaysResponse: groupTimetableResponse.evenWeek)
        groupTimetable.weeks.append(groupOddWeek)
        groupTimetable.weeks.append(groupEvenWeek)
        
        return groupTimetable
    }
    
    private static func converteGroupDaysResponseToRGroupWeek(groupDaysResponse: [GroupDayResponse]) -> RGroupWeek {
        let groupWeek = RGroupWeek()
        
        for groupDayResponse in groupDaysResponse {
            let groupDay = RGroupDay()
            
            groupDay.number = groupDayResponse.number
            
            for groupLessonResponse in groupDayResponse.lessons {
                let groupLesson = RGroupLesson()
                
                groupLesson.time = groupLessonResponse.time
                
                for groupSubgroupResponse in groupLessonResponse.subgroups {
                    let groupSubgroup = RGroupSubgroup()
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
            rGroup.email = groupResponse.email
            
            rGroups.append(rGroup)
        }
        
        return rGroups
    }
    
}
