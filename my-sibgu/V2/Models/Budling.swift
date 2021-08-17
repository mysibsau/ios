//
//  BudlingResponse.swift
//  my-sibgu
//
//  Created by art-off on 03.01.2021.
//

import Foundation
import RealmSwift

// MARK: - Request
class BuildingRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    
    typealias Response = [Building]
    
    var path: String { "/campus/buildings/" }
}

// MARK: - Model
class Building: Decodable {
    
    let id: Int
    let name: String
    let type: String
    let address: String
    let coast: Coast
    private let urlTo2gisString: String
    var urlTo2gis: URL {
        URL(string: urlTo2gisString)!
    }
    
    init(id: Int, name: String, type: String, address: String, coast: Coast, urlTo2gisString: String) {
        self.id = id
        self.name = name
        self.type = type
        self.address = address
        self.coast = coast
        self.urlTo2gisString = urlTo2gisString
    }
    
    enum Coast: Int, Decodable {
        case left
        case right
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case address
        case coast
        case urlTo2gisString = "link"
    }
}

extension Building: Equatable {
    
    static func == (lhs: Building, rhs: Building) -> Bool {
        lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.type == rhs.type
            && lhs.address == rhs.address
            && lhs.coast == rhs.coast
            && lhs.urlTo2gisString == rhs.urlTo2gisString
    }
}

extension Building: Storable {
    
    var storeModel: RBuilding {
        let b = RBuilding()
        b.id = id
        b.name = name
        b.type = type
        b.address = address
        b.coast = coast.rawValue
        b.urlTo2gis = urlTo2gisString
        return b
    }
}

// MARK: - Store Model
class RBuilding: Object, ConvertableToApp {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var address = ""
    @objc dynamic var coast = 0
    @objc dynamic var urlTo2gis = ""
    
    
    override class func primaryKey() -> String? { "id" }
    
    var toAppModel: Building {
        Building(id: id,
                 name: name,
                 type: type,
                 address: address,
                 coast: Building.Coast(rawValue: coast) ?? .left,
                 urlTo2gisString: urlTo2gis)
    }
}
