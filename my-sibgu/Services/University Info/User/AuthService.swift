//
//  AuthService.swift
//  my-sibgu
//
//  Created by art-off on 10.02.2021.
//

import Foundation

class UserService {
    
    func getCurrUser() -> User? {
        return DataManager.shared.getCurrUser()
    }
    
    func outCurrUser() {
        DataManager.shared.replaceCurrUser(on: nil)
        UserDefaultsConfig.userStudentId = nil
        UserDefaultsConfig.userPassword = nil
    }
    
    func authUser(number: String, password: String, completion: @escaping (User?) -> Void) {
        ApiUserService().authUser(number: number, password: password) { userResponse in
            guard let userResponse = userResponse else {
                DispatchQueue.main.async {
                    DataManager.shared.replaceCurrUser(on: nil)
                    UserDefaultsConfig.userStudentId = nil
                    UserDefaultsConfig.userPassword = nil
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                DataManager.shared.replaceCurrUser(on: userResponse.converteToRealm())
                UserDefaultsConfig.userStudentId = number
                UserDefaultsConfig.userPassword = password
                let userForShowing = DataManager.shared.getCurrUser()
                completion(userForShowing)
            }
        }
    }
    
}
