//
//  ArtAssociation.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.08.2021.
//

import Foundation
import RealmSwift

// MARK: - Request
struct ArtAssociationRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    typealias Response = [ArtAssociation]
    
    var path: String { "/campus/ensembles" }
}

// MARK: - Model
struct ArtAssociation: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let contacts: String
    
    private let logoString: String
    var logo: URL {
        URL(string: NetworkingConstants.mysibsauServerAddress + logoString)!
    }
    private let vkLinkString: String
    var vkLink: URL? {
        URL(string: vkLinkString)
    }
    private let instagramLinkString: String
    var instagramLink: URL? {
        URL(string: instagramLinkString)
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

extension ArtAssociation: Equatable { }

extension ArtAssociation: Storable {
    
    var storeModel: RArtAssociation {
        let rAA = RArtAssociation()
        rAA.id = id
        rAA.name = name
        rAA.logo = logoString
        rAA.description1 = description
        rAA.contacts = contacts
        rAA.vkLink = vkLinkString
        rAA.instaLink = instagramLinkString
        return rAA
    }
}

// MARK: - RModel
class RArtAssociation: Object, ConvertableToApp {
    
    @objc dynamic var id = 0
    @objc dynamic var logo = ""
    @objc dynamic var name = ""
    @objc dynamic var description1 = ""
    @objc dynamic var contacts = ""
    @objc dynamic var vkLink = ""
    @objc dynamic var instaLink = ""
    
    override class func primaryKey() -> String? { "id" }
    
    var toAppModel: ArtAssociation {
        ArtAssociation(id: id,
                       name: name,
                       description: description1,
                       contacts: contacts,
                       logoString: logo,
                       vkLinkString: vkLink,
                       instagramLinkString: instaLink)
    }
}
