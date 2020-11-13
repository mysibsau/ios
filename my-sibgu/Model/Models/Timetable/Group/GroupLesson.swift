//
//  GroupLesson.swift
//  my-sibgu
//
//  Created by art-off on 12.11.2020.
//

import Foundation

struct GroupLesson {
    
    let time: String
    let subgroups: [GroupSubgroup]
    
}

struct GroupSubgroup {
    
    let number: Int
    let subject: String
    let type: String
    let professor: String
    //let professorsId: [Int]
    let place: String
    //let placeId: Int?
    
}
