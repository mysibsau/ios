//
//  ConvertableProtocols.swift
//  my-sibgu
//
//  Created by Artem Rylov on 11.08.2021.
//

import Foundation
import RealmSwift

protocol ConvertableToSrore {
    
    associatedtype RealmProtocol: Object
    
    var toStoreModel: RealmProtocol { get }
}

protocol ConvertableToApp {
    
    associatedtype AppProtocol: ConvertableToSrore
    
    var toAppModel: AppProtocol { get }
}
