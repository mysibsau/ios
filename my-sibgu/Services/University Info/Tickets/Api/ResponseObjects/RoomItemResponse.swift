//
//  RoomItemResponse.swift
//  my-sibgu
//
//  Created by art-off on 25.03.2021.
//

import Foundation

class RoomItemResponse: Decodable {
    let id: Int
    let row: Int
    let place: Int
    let price: Double
}

extension RoomItemResponse {
    func converteToDomain() -> RoomItem {
        return RoomItem(id: id, row: row, place: place, price: price)
    }
}
