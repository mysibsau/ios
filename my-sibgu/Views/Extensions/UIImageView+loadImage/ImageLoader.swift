//
//  ImageLoader.swift
//  my-sibgu
//
//  Created by art-off on 05.12.2020.
//

import UIKit

class ImageLoader {
    
    // поле, которое можно юзать для того, чтобы включать сохранение файлов в Documents
    // private let saveToDocuments: Bool
    
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    
    init(saveToDocuments: Bool = true) {
        //self.saveToDocuments = saveToDocuments
    }
    
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
//        print(loadedImages)
//        print(loadedImages[url])
//        print(url)
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        // Если он уже скачан и сохранен
        if let image = FileHelper.shared.getImageFromDocumtest(with: url.path) {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                self.runningRequests.removeValue(forKey: uuid)
            }
            
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
                FileHelper.shared.saveImageToDocuments(image: image, with: url.path)
                completion(.success(image))
                return
            }
            
            guard let error = error else {
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
    
}
