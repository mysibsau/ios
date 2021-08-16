//
//  ArtAssociation.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.08.2021.
//

import Foundation
import RealmSwift

struct ArtAssociationRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    typealias Response = [ArtAssociation]
    
    var path: String { "/campus/ensembles" }
}

struct ArtAssociation: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let contacts: String
    
    private let logoString: String
    var logo: URL {
        URL(string: NetworkingConstants.mysibsauServerAddress + logoString)!
    }
    
    init(id: Int, name: String, description: String, contacts: String, logoString: String) {
        self.id = id
        self.name = name
        self.description = description
        self.contacts = contacts
        self.logoString = logoString
    }
    
    enum CodingKeys: String, CodingKey {
        case id,
             logoString = "logo",
             name,
             description = "about",
             contacts
    }
}

extension ArtAssociation: Equatable { }

extension ArtAssociation: Storable {
    
    var storeModel: RArtAssociation {
        let rAA = RArtAssociation()
        rAA.id = id
        rAA.name = name
        rAA.logo = logoString
        rAA.description1 = description
        rAA.contacts = contacts
        return rAA
    }
}

class RArtAssociation: Object, ConvertableToApp {
    
    @objc dynamic var id = 0
    @objc dynamic var logo = ""
    @objc dynamic var name = ""
    @objc dynamic var description1 = ""
    @objc dynamic var contacts = ""
    
    override class func primaryKey() -> String? { return "id" }
    
    var toAppModel: ArtAssociation {
        ArtAssociation(id: id,
                       name: name,
                       description: description,
                       contacts: contacts,
                       logoString: logo)
    }
}
