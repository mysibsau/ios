//
//  String+capitalizinFirstLetter.swift
//  my-sibgu
//
//  Created by art-off on 12.11.2020.
//

import Foundation

extension String {
    
    func capitalizinFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }
    
}
