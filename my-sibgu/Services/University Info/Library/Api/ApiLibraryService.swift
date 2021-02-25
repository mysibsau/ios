//
//  ApiLibraryService.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import Foundation

class ApiLibraryService {
    
    private let baseApiService = BaseApiService()
    
    
    func loadBooks(by searchText: String, completion: @escaping (_ faq: BooksResponse?) -> Void) {
        baseApiService.load(BooksResponse.self, url: ApiLibrary.books(by: searchText), completion: completion)
    }
    
}
