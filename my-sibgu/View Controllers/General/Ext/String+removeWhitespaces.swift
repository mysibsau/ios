//
//  String+removeWhitespaces.swift
//  my-sibgu
//
//  Created by art-off on 04.01.2021.
//

import Foundation

extension String {
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
}
