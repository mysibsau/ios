//
//  LibraryService.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import Foundation

typealias BooksBallback = ([DigitalBook], [PhysicalBook])

class LibraryService {
    
    func getBooks(by searchText: String, completion: @escaping (BooksBallback?) -> Void) {
        ApiLibraryService().loadBooks(by: searchText) { booksResponse in
            guard let booksResponse = booksResponse else {
                completion(nil)
                return
            }
            
            completion((
                booksResponse.digital.map { $0.converteToDomain() },
                booksResponse.physical.map { $0.converteToDomain() }
            ))
        }
    }
    
}
