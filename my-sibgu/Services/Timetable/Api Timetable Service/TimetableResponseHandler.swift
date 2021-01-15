//
//  TimetableResponseHandler.swift
//  my-sibgu
//
//  Created by art-off on 13.11.2020.
//

import Foundation

class TimetableResponseHandler {
    
    // MARK: Обработка скачанных групп
    static func handleGroupsResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> [RGroup]? {
        guard error == nil else { return nil }
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else { return nil }
        guard let data = data else { return nil }
        
        do {
            let groupsResponse = try JSONDecoder().decode([GroupResponse].self, from: data)
            let groups = ResponseTranslator.converteGroupResponseToRGroup(groupsResponse: groupsResponse)
            return groups
        } catch let jsonError {
            print(jsonError)
            return nil
        }
    }
    
    // MARK: Обработка скачанного хеша
    static func handleHashResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> String? {
        guard error == nil else { return nil }
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else { return nil }
        guard let data = data else { return nil }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let hash = json["hash"] as? String else {
                    return nil
            }
            return hash
        } catch let jsonError {
            print(jsonError)
            return nil
        }
    }
    
    // MARK: Обработка скачанного расписания групп
    static func handleGroupTimetableResponse(groupId: Int, _ data: Data?, _ response: URLResponse?, _ error: Error?) -> (timetable: RGroupTimetable?, groupHash: String?) {
        guard error == nil else { return (nil, nil) }
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else { return (nil, nil) }
        guard let data = data else { return (nil, nil) }
        
        do {
            let groupTimetableResponse = try JSONDecoder().decode(GroupTimetableResponse.self, from: data)
            
            // Антон отправляет массивом с одним элементом (:
//            guard let groupTimetableResponseFirst = groupTimetableResponse.first else { return (nil, nil) }
            
            let groupTimetable = ResponseTranslator.converteGroupTimetableResponseToRGroupTimetable(
                groupTimetableResponse: groupTimetableResponse,
                groupId: groupId)
            
            return (groupTimetable, groupTimetableResponse.meta.groupsHash)
        } catch let jsonError {
            print(jsonError)
            return (nil, nil)
        }
    }
    
}
