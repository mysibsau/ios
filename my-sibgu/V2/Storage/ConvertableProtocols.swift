//
//  ConvertableProtocols.swift
//  my-sibgu
//
//  Created by Artem Rylov on 11.08.2021.
//

import Foundation
import RealmSwift

protocol ConvertableToSrore {
    
    var toStoreModel: Object { get }
}

protocol ConvertableToApp {
    
    associatedtype AppProtocol: ConvertableToSrore
    
    var toAppModel: AppProtocol { get }
}


protocol Storable: ConvertableToSrore {
    
    associatedtype StoreType: Object, ConvertableToApp where StoreType.AppProtocol == Self
    var storeModel: StoreType { get }
}
extension Storable {
    var toStoreModel: Object { storeModel }
}
