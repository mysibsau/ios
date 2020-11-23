//
//  UniversityInfoService.swift
//  my-sibgu
//
//  Created by art-off on 14.11.2020.
//

import Foundation

class UniversityInfoService {
    
    func getBuildings(completion: @escaping (_ buildings: [Building]?) -> Void) {
        let building1 = Building(coast: "Правый", name: "Корпус \"А\"", urlTo2gis: URL(string: "https://2gis.ru/krasnoyarsk/geo/985798073679672/92.918363%2C56.048699?m=92.91748%2C56.047991%2F17.31")!)
        let building2 = Building(coast: "Правый", name: "Корпус \"Б\"", urlTo2gis: URL(string: "https://2gis.ru/krasnoyarsk/geo/985798073679672/92.918363%2C56.048699?m=92.91748%2C56.047991%2F17.31")!)
        let building3 = Building(coast: "Левый", name: "Корпус \"В\"", urlTo2gis: URL(string: "https://2gis.ru/krasnoyarsk/geo/985798073679672/92.918363%2C56.048699?m=92.91748%2C56.047991%2F17.31")!)
        let building4 = Building(coast: "Левый", name: "Корпус \"Г\"", urlTo2gis: URL(string: "https://2gis.ru/krasnoyarsk/geo/985798073679672/92.918363%2C56.048699?m=92.91748%2C56.047991%2F17.31")!)
        
        completion([building1, building2, building3, building4])
    }
    
    func getInstitutes(completion: @escaping (_ institutes: [Institute]?) -> Void) {
        
        //let director = Institute.Director(name: "Директор", address: "Адресс", phone: "8484848484", email: "tema@iclo.com", imageUrl: URL(string: "www.ff.com")!)
        
        //let institute = Institute(name: "первый", director: <#T##Institute.Director#>, departments: <#T##[Institute.Department]#>, soviet: <#T##Institute.Soviet#>)
    }
    
}
