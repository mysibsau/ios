//
//  InstituteResponse.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation

class InstituteResponse: Decodable {
    
    let name: String
    let shortName: String
    let director: DirectorResponse
    let departments: [DepartmentResponse]
    let soviet: SovietResponse
    
    enum CodingKeys: String, CodingKey {
        case name
        case shortName = "short_name"
        case director
        case departments
        case soviet
    }
    
}

class DirectorResponse: Decodable {
    
    let name: String
    let imageUrl: String
    let address: String
    let phone: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image"
        case address
        case phone
        case email = "mail"
    }
    
}

class DepartmentResponse: Decodable {
    
    let name: String
    let leaderName: String
    let address: String
    let phone: String?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case leaderName = "fio"
        case address
        case phone
        case email = "mail"
    }
    
}

class SovietResponse: Decodable {
    
    let imageUrl: String
    let leaderName: String
    let address: String
    let phone: String?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image"
        case leaderName = "fio"
        case address
        case phone
        case email = "mail"
    }
    
}


extension InstituteResponse: ConvertableToRealm {

    func converteToRealm() -> RInstitute {
        let i = RInstitute()
        i.name = self.name
        i.shortName = self.shortName
        i.director = self.director.converteToRealm()
        i.departments.removeAll()
        for department in self.departments {
            i.departments.append(department.converteToRealm())
        }
        i.soviet = self.soviet.converteToRealm()
        return i
    }
    
}

extension DirectorResponse: ConvertableToRealm {
    
    func converteToRealm() -> RDirector {
        let d = RDirector()
        d.name = self.name
        d.imageUrl = self.imageUrl
        d.address = self.address
        d.phone = self.phone
        d.email = self.email
        return d
    }
    
}

extension DepartmentResponse: ConvertableToRealm {
    
    func converteToRealm() -> RDepartment {
        let d = RDepartment()
        d.name = self.name
        d.leaderName = self.leaderName
        d.address = self.address
        d.phone = self.phone
        d.email = self.email
        return d
    }
    
}

extension SovietResponse: ConvertableToRealm {
    
    func converteToRealm() -> RSoviet {
        let s = RSoviet()
        s.imageUrl = self.imageUrl
        s.leaderName = self.leaderName
        s.address = self.address
        s.phone = self.phone
        s.email = self.email
        return s
    }
    
}
