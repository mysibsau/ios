//
//  GetModelsService.swift
//  my-sibgu
//
//  Created by Artem Rylov on 11.08.2021.
//

import Foundation
import RealmSwift

class GetModelsService {
    
    static let shared = GetModelsService()
    
    private let databaseManager: DatabaseManager
    private let requestService: RequestServise
    
    init(databaseManager: DatabaseManager = .shared,
         requestService: RequestServise = .shared) {
        self.databaseManager = databaseManager
        self.requestService = requestService
    }
    
    func loadAndStoreIfPossible<R1: Request>(_ request1: R1, deleteActionBeforeWriting: (() -> Void)?, completion: @escaping (R1.Response?) -> Void) {
        _loadAndStoreIfPossible(request1, nil as R1?, nil as R1?, deleteActionBeforeWriting: deleteActionBeforeWriting) { r1, _,_ in
            completion(r1)
        }
    }
    
    func loadAndStoreIfPossible<R1: Request,
                                R2: Request>(_ request1: R1, _ request2: R2,
                                             deleteActionBeforeWriting: (() -> Void)?,
                                             completion: @escaping (R1.Response?, R2.Response?) -> Void) {
        _loadAndStoreIfPossible(request1, request2, nil as R1?, deleteActionBeforeWriting: deleteActionBeforeWriting) { r1, r2, _ in
            completion(r1, r2)
        }
    }
    
    func loadAndStoreIfPossible<R1: Request,
                                R2: Request,
                                R3: Request>(_ request1: R1, _ request2: R2, _ request3: R3,
                                             deleteActionBeforeWriting: (() -> Void)?,
                                             completion: @escaping (R1.Response?,
                                                                    R2.Response?,
                                                                    R3.Response?) -> Void) {
        _loadAndStoreIfPossible(request1, request2, request3, deleteActionBeforeWriting: deleteActionBeforeWriting) { r1, r2, r3 in
            completion(r1, r2, r3)
        }
    }
    
    func getFromStore<S1: Storable>(type: S1.Type) -> [S1.StoreType.AppProtocol] {
        databaseManager.get(S1.StoreType.self).map(\.toAppModel)
    }
}

// MARK: - Helper
extension GetModelsService {
    
    // RequestService allows perform 7 request sync
    private func _loadAndStoreIfPossible<R1: Request,
                                         R2: Request,
                                         R3: Request>(_ request1: R1?, _ request2: R2?, _ request3: R3?,
                                                      deleteActionBeforeWriting: (() -> Void)?,
                                                      completion: @escaping (R1.Response?,
                                                                             R2.Response?,
                                                                             R3.Response?) -> Void) {
        requestService._perform(request1, request2, request3,
                                nil as R1?, nil as R1?, nil as R1?) { r1, r2, r3, _,_,_ in
            
            DispatchQueue.main.async {
                deleteActionBeforeWriting?()
            }
            
//            print("EEEEE", r1, r1 is ConvertableToSrore)
//            print("EEEEE", r2, r2 is ConvertableToSrore)
//            print("EEEEE", r3, r3 is ConvertableToSrore)
            
            var convertablesToStore: [ConvertableToSrore] = []
            
            // TODO: 1. now store only `ConvertableToSrore` and `[ConvertableToSrore]`
            // TODO: 1. if `[[ConvertableToSrore]]`, it will not store
            // TODO: 2. What the fuck it
            if let convertable = r1 as? ConvertableToSrore {
                convertablesToStore.append(convertable)
            } else if let convertables = r1 as? [ConvertableToSrore] {
                convertablesToStore += convertables
            }
            if let convertable = r2 as? ConvertableToSrore {
                convertablesToStore.append(convertable)
            } else if let convertables = r2 as? [ConvertableToSrore] {
                convertablesToStore += convertables
            }
            if let convertable = r3 as? ConvertableToSrore {
                convertablesToStore.append(convertable)
            } else if let convertables = r3 as? [ConvertableToSrore] {
                convertablesToStore += convertables
            }
            
            convertablesToStore.forEach { convertable in
                DispatchQueue.main.async {
                    self.databaseManager.write(convertable.toStoreModel)
                }
            }
            // In 'main' because write in DB should end firstly
            DispatchQueue.main.async {
                completion(r1, r2, r3)
            }
        }
    }
    
    private static func storeResponse(convertables: [ConvertableToSrore]) {
        
    }
}
