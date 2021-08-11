//
//  ConvertableProtocols.swift
//  my-sibgu
//
//  Created by Artem Rylov on 11.08.2021.
//

import Foundation
import RealmSwift

protocol ConvertableToSrore {
    
    associatedtype StoreProtocol: Object
    
    var toStoreModel: StoreProtocol { get }
}

protocol ConvertableToApp {
    
    associatedtype AppProtocol: ConvertableToSrore
    
    var toAppModel: AppProtocol { get }
}
