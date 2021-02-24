//
//  CafeteriaResponse.swift
//  my-sibgu
//
//  Created by art-off on 21.02.2021.
//

import Foundation

class CafeteriaResponse: Decodable {
    
    let name: String
    let menus: [MenuResponse]
    
    enum CodingKeys: String, CodingKey {
        case name
        case menus = "menu"
    }
    
}

class MenuResponse: Decodable {
    
    let type: String
    let diners: [DinerResponse]
    
}

class DinerResponse: Decodable {
    
    let name: String
    let weight: String
    let price: Double
    let included: String?
    
    
    enum CodingKeys: String, CodingKey {
        case name = "diner_name"
        case weight
        case price
        case included
    }
}

extension CafeteriaResponse {
    func converteToDomain() -> Cafeteria {
        return Cafeteria(name: name, menus: menus.map { $0.converteToDomain() })
    }
}

extension MenuResponse {
    func converteToDomain() -> Menu {
        return Menu(type: type, diners: diners.map { $0.converteToDomain() })
    }
}

extension DinerResponse {
    func converteToDomain() -> Diner {
        return Diner(name: name, weight: weight, price: price, included: included)
    }
}
