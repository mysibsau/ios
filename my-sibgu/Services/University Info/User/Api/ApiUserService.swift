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
    
}
