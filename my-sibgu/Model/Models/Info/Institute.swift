//
//  Institute.swift
//  my-sibgu
//
//  Created by art-off on 17.11.2020.
//

import Foundation

struct Institute {
    
    let name: String
    let shortName: String
    
    let director: Director
    let departments: [Department]
    let soviet: Soviet
    
    // потом изменится (в ходе программы)
    static var universityLogoUrl = URL(string: "https://timetable.mysibsau.ru")
    
}
