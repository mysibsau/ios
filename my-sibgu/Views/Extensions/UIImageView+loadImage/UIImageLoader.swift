//
//  UIImageLoader.swift
//  my-sibgu
//
//  Created by art-off on 05.12.2020.
//

import UIKit

class UIImageLoader {
    
    static let loader = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    
    private init() {}
    
    
    func load(_ url: URL, for imageView: UIImageView) {
        let token = imageLoader.loadImage(url) { result in
            defer {
                self.uuidMap.removeValue(forKey: imageView)
            }
            
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
                NSLog("Не загрузилась фоточка по \(url)")
            }
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
    
}
