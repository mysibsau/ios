//
//  Distionary+Plus.swift
//  my-sibgu
//
//  Created by Artem Rylov on 10.08.2021.
//

import Foundation

extension Dictionary {
    
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        lhs.merging(rhs, uniquingKeysWith: { $1 })
    }
    
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        lhs = lhs + rhs
    }
}

