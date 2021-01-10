//
//  ImageResponse.swift
//  my-sibgu
//
//  Created by art-off on 10.01.2021.
//

import Foundation

class ImageResponse: Decodable {
    
    let url: String
    let width: Int
    let height: Int
    
}

extension ImageResponse {
    
    func converteToDomain() -> Image {
        return Image(
            url: ApiUniversityInfo.download(with: self.url),
            width: self.width,
            height: self.height
        )
    }
    
}
