//
//  DesignOfficeResponse.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import Foundation

class DesignOfficeResponse: Decodable {
    
    let id: Int
    let address: String
    let about: String
    let fio: String?
    let email: String?
    
}

extension DesignOfficeResponse: ConvertableToRealm {

    func converteToRealm() -> RDesingOffice {
        let desingOffice = RDesingOffice()
        desingOffice.id = id
        desingOffice.address = address
        desingOffice.about = about
        desingOffice.fio = fio
        desingOffice.email = email
        return desingOffice
    }
    
}
