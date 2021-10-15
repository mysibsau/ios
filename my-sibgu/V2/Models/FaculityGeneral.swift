//
//  FaculityGeneral.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.10.2021.
//

import Foundation
import RealmSwift

// MARK: - Request
struct FaculityGeneralRequest: Request, RequestWithDefaultQueryParams, RequestWithDefaultHeaderParams {
    typealias Response = FaculityGeneral
    
    var apiVersion: RequestModel.Version { .v3 }
    var path: String { "/campus/faculties/technogalaxy_info/" }
}

// MARK: - Model
struct FaculityGeneral: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let contacts: String?
    
    private let logoString: String
    var logo: URL {
        URL(string: NetworkingConstants.mysibsauServerAddress + logoString)!
    }
    private let vkLinkString: String?
    var vkLink: URL? {
        URL(string: vkLinkString ?? "")
    }
    private let instagramLinkString: String?
    var instagramLink: URL? {
        URL(string: instagramLinkString ?? "")
    }
    /// Это для вступления в группу
    private let vkPageString: String?
    var vkPage: URL? {
        URL(string: vkPageString ?? "")
    }
    
    init(id: Int, name: String, description: String, contacts: String?,
         logoString: String, vkLinkString: String?, instagramLinkString: String?, vkPageString: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.contacts = contacts
        self.logoString = logoString
        self.vkLinkString = vkLinkString
        self.instagramLinkString = instagramLinkString
        self.vkPageString = vkPageString
    }
    
    enum CodingKeys: String, CodingKey {
        case id,
             logoString = "logo",
             name,
             description = "about",
             contacts,
             vkLinkString = "vk_link",
             instagramLinkString = "instagram_link",
             vkPageString = "page_vk"
    }
}

extension FaculityGeneral: Equatable { }

extension FaculityGeneral: Storable {
    
    var storeModel: RFaculityGeneral {
        let rAA = RFaculityGeneral()
        rAA.id = id
        rAA.name = name
        rAA.logo = logoString
        rAA.description1 = description
        rAA.contacts = contacts
        rAA.vkLink = vkLinkString
        rAA.instaLink = instagramLinkString
        rAA.vkPage = vkPageString
        return rAA
    }
}

// MARK: - RModel
class RFaculityGeneral: Object, ConvertableToApp {
    
    @objc dynamic var id = 0
    @objc dynamic var logo = ""
    @objc dynamic var name = ""
    @objc dynamic var description1 = ""
    @objc dynamic var contacts: String? = nil
    @objc dynamic var vkLink: String? = nil
    @objc dynamic var vkPage: String? = nil
    @objc dynamic var instaLink: String? = nil
    
    override class func primaryKey() -> String? { "id" }
    
    var toAppModel: FaculityGeneral {
        FaculityGeneral(id: id,
                 name: name,
                 description: description1,
                 contacts: contacts,
                 logoString: logo,
                 vkLinkString: vkLink,
                 instagramLinkString: instaLink,
                 vkPageString: vkPage)
    }
}

