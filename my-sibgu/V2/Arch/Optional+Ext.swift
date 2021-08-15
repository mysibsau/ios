//
//  Optional+Ext.swift
//  my-sibgu
//
//  Created by Artem Rylov on 09.08.2021.
//

import Foundation

extension Optional {
    
    func `let`(_ block: (Wrapped) -> Void) {
        if let value = self {
            block(value)
        }
    }
}
