//
//  NewsResponse.swift
//  my-sibgu
//
//  Created by art-off on 14.01.2021.
//

import Foundation

class NewsResponse: Decodable {
    
    let id: Int
    let text: String
    let countViews: Int
    let countLikes: Int
    let isLiked: Bool
    
    let images: [ImageResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case countViews = "views"
        case countLikes = "likes"
        case isLiked = "is_liked"
        case images
    }
    
}

extension NewsResponse {

    func converteToDomain() -> News {
        return News(
            id: self.id,
            text: self.text,
            countViews: self.countViews,
            countLikes: self.countLikes,
            isLiked: self.isLiked,
            images: self.images.map { $0.converteToDomain() }
        )
    }

}
