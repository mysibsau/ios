//
//  ApiAuthService.swift
//  my-sibgu
//
//  Created by art-off on 10.02.2021.
//

import Foundation

class ApiUserService {
    
    private let baseApiService = BaseApiService()
    
    
    func authUser(number: String, password: String, completion: @escaping (_ faq: UserResponse?) -> Void) {
        baseApiService.load(UserResponse.self, url: ApiUser.authUser(number: number, password: password), completion: completion)
    }
    
    func loadMarks(number: String, password: String, completion: @escaping (_ marksResponse: [MarksResponse]?) -> Void) {
        baseApiService.load([MarksResponse].self, url: ApiUser.marks(number: number, password: password), completion: completion)
    }
    
    func loadAttestation(number: String, password: String, completion: @escaping (_ attestations: [AttestationItemResponse]?) -> Void) {
        baseApiService.load([AttestationItemResponse].self, url: ApiUser.attestations(number: number, password: password), completion: completion)
    }
    
}
