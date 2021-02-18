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
    
    func getMarks(completion: @escaping ([Marks]?) -> Void) {
        guard
            let number = UserDefaultsConfig.userStudentId,
            let password = UserDefaultsConfig.userPassword
        else {
            completion(nil)
            return
        }
        
        ApiUserService().loadMarks(number: number, password: password) { marksResponse in
            completion(marksResponse?.map { $0.converteToDomain() })
        }
    }
    
    func getAttestation(completion: @escaping ([AttestationItem]?) -> Void) {
        guard
            let number = UserDefaultsConfig.userStudentId,
            let password = UserDefaultsConfig.userPassword
        else {
            completion(nil)
            return
        }
        
        ApiUserService().loadAttestation(number: number, password: password) { attestationItemsResponse in
            completion(attestationItemsResponse?.map { $0.converteToDomain() })
        }
    }
    
}
