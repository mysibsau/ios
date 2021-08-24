//
//  HashRequests.swift
//  my-sibgu
//
//  Created by Artem Rylov on 19.08.2021.
//

import Foundation

struct GroupsHashRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    
    typealias Response = HashResponse
    
    var path: String { "/timetable/hash/groups/" }
}

struct ProfessorsHashRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    
    typealias Response = HashResponse
    
    var path: String { "/timetable/hash/teachers/" }
}

struct PlacesHashRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    
    typealias Response = HashResponse
    
    var path: String { "/timetable/hash/places" }
}
