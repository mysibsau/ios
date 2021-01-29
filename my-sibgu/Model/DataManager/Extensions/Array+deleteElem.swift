//
//  Array+deleteElem.swift
//  my-sibgu
//
//  Created by art-off on 29.01.2021.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func delete(elem: Element) {
        if let index = self.firstIndex(where: { $0 == elem }) {
            self.remove(at: index)
        }
    }
    
}
