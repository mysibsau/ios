//
//  GetModelsService.swift
//  my-sibgu
//
//  Created by Artem Rylov on 11.08.2021.
//

import Foundation

class GetModelsService<T: Request> {
    
    private let databaseManager: DatabaseManager
    private let requestService: RequestServise
    
    private let request: T
    
    init(request: T,
         databaseManager: DatabaseManager = .shared,
         requestService: RequestServise = .shared) {
        self.request = request
        self.databaseManager = databaseManager
        self.requestService = requestService
    }
    
    func load(fromApi: @escaping (T.Response?) -> Void) {
        requestService.perform(request, completion: fromApi)
    }
}

// When can store T.Reaponse
// Also
// AppModel -> SroteModel and SroteModel -> AppModel
extension GetModelsService where T.Response: ConvertableToSrore,
                                 T.Response.StoreProtocol: ConvertableToApp,
                                 T.Response.StoreProtocol.AppProtocol == T.Response {
    
    func getFromStore() -> [T.Response] {
        databaseManager.get(T.Response.StoreProtocol.self)
            .map(\.toAppModel)
    }
    
    func getFromStoreAndLoad(fromApi: @escaping (T.Response?) -> Void) -> [T.Response] {
        load(fromApi: fromApi)
        return getFromStore()
    }
}
