//
//  DesignOffice+Equatable.swift
//  my-sibgu
//
//  Created by art-off on 05.02.2021.
//

import Foundation

extension DesignOffice: Equatable {
    
    static func == (lhs: DesignOffice, rhs: DesignOffice) -> Bool {
        let id = lhs.id == rhs.id
        let fio = lhs.fio == rhs.fio
        let address = lhs.address == rhs.address
        let email = lhs.email == rhs.email
        let about = lhs.about == rhs.about
        
        return id && email && fio && address && about
    }
    
}
