//
//  ArtAssociationGeneral.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.08.2021.
//

import Foundation
import RealmSwift

// MARK: - Request
struct ArtAssociationGeneralRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    typealias Response = ArtAssociationGeneral
    
    var path: String { "/campus/ensembles/ktc_info/" }
}

// MARK: - Model
struct ArtAssociationGeneral: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let contacts: String
    
    private let vkLinkString: String
    var vkLink: URL? {
        URL(string: vkLinkString)
    }
    private let instagramLinkString: String
    var instagramLink: URL? {
        URL(string: instagramLinkString)
    }
    private let logoString: String
    var logo: URL {
        URL(string: NetworkingConstants.mysibsauServerAddress + logoString)!
    }
    
    init(id: Int, name: String, description: String, contacts: String, logoString: String, vkLinkString: String, instagramLinkString: String) {
        self.id = id
        self.name = name
        self.description = description
        self.contacts = contacts
        self.logoString = logoString
        self.vkLinkString = vkLinkString
        self.instagramLinkString = instagramLinkString
    }
    
    enum CodingKeys: String, CodingKey {
        case id,
             logoString = "logo",
             name,
             description = "about",
             contacts,
             vkLinkString = "vk_link",
             instagramLinkString = "instagram_link"
    }
}

extension ArtAssociationGeneral: Equatable { }

extension ArtAssociationGeneral: Storable {
    
    var storeModel: RArtAssociationGeneral {
        let rAA = RArtAssociationGeneral()
        rAA.id = id
        rAA.name = name
        rAA.logo = logoString
        rAA.vkLink = vkLinkString
        rAA.instagramLink = instagramLinkString
        rAA.description1 = description
        rAA.contacts = contacts
        return rAA
    }
}

// MARK: - RModel
class RArtAssociationGeneral: Object, ConvertableToApp {
    
    @objc dynamic var id = 0
    @objc dynamic var logo = ""
    @objc dynamic var vkLink = ""
    @objc dynamic var instagramLink = ""
    @objc dynamic var name = ""
    @objc dynamic var description1 = ""
    @objc dynamic var contacts = ""
    
    override class func primaryKey() -> String? { return "id" }
    
    var toAppModel: ArtAssociationGeneral {
        ArtAssociationGeneral(id: id,
                              name: name,
                              description: description1,
                              contacts: contacts,
                              logoString: logo,
                              vkLinkString: vkLink,
                              instagramLinkString: instagramLink)
    }
}
