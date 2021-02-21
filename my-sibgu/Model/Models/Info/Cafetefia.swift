//
//  Cafetefia.swift
//  my-sibgu
//
//  Created by art-off on 20.02.2021.
//

import Foundation

struct Cafeteria {
    
    let name: String
    let menus: [Menu]
    
}

struct Menu {
    
    let type: String
    let diners: [Diner]
    
}

struct Diner {
    
    let name: String
    let weight: String
    let price: Double
    
}
