//
//  EventResponse.swift
//  my-sibgu
//
//  Created by art-off on 09.01.2021.
//

import Foundation

class EventResponse: Decodable {
    
    let id: Int
    let name: String
    let text: String
    let countViews: Int
    let countLikes: Int
    let isLiked: Bool
    
    let logo: ImageResponse
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case text
        case countViews = "views"
        case countLikes = "likes"
        case isLiked = "is_liked"
        case logo
    }
    
}

extension EventResponse {
    
    func converteToDomain() -> Event {
        return Event(
            id: self.id,
            name: self.name,
            text: self.text,
            countViews: self.countViews,
            countLikes: self.countLikes,
            isLiked: self.isLiked,
            logo: self.logo.converteToDomain()
        )
    }
    
}
