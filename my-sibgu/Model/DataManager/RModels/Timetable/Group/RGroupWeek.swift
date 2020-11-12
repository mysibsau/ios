//
//  RGroupWeek.swift
//  my-sibgu
//
//  Created by art-off on 12.11.2020.
//
//

import Foundation
import RealmSwift

class RGroupWeek: Object {
    
    @objc dynamic var number = 0
    let days = List<RGroupDay>()
    
}
