//
//  DictableType.swift
//  my-sibgu
//
//  Created by Artem Rylov on 16.08.2021.
//

import Foundation

protocol DictableType {
    
    var dict: [String: String] { get }
}

func allDefaultParamsDict(by params: [DictableType]) -> [String: String] {
    var dict: [String: String] = [:]
    params.forEach {
        dict += $0.dict
    }
    return dict
}
