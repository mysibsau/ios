//
//  AttestationItemResponse.swift
//  my-sibgu
//
//  Created by art-off on 18.02.2021.
//

import Foundation

class AttestationItemResponse: Decodable {
    
    let name: String
    let type: String
    let att1: String
    let att2: String
    let att3: String
    let att: String
    
}

extension AttestationItemResponse {
    
    func converteToDomain() -> AttestationItem {
        return AttestationItem(
            name: name,
            type: type,
            att1: att1,
            att2: att2,
            att3: att3,
            att: att
        )
    }
    
}
