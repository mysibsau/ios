//
//  FileHelper.swift
//  my-sibgu
//
//  Created by art-off on 08.01.2021.
//

import Foundation
import UIKit

class FileHelper {
    
    static let shared = FileHelper()
    
    private let fileManager: FileManager
    private let filesDirectory: URL
    
    private init() {
        fileManager = FileManager.default
        filesDirectory = DataManager.shared.filesDirectoryUrl
    }
    
    func saveImageToDocuments(image: UIImage, with name: String) {
        // Имя без `/` потому что нельзя нельзя сохранять файлы с `/`
        let safeName = name.replacingOccurrences(of: "/", with: ":")
        
        let fileUrl = filesDirectory.appendingPathComponent(safeName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        // Если уже есть, то удаляем, что-бы перезаписать
        if fileManager.fileExists(atPath: fileUrl.path) {
            do {
                try fileManager.removeItem(at: fileUrl)
            } catch {
                NSLog("Не удалили файл \(safeName)")
            }
        }
        
        do {
            print(fileUrl)
            try data.write(to: fileUrl)
            NSLog("Все норм")
        } catch {
            NSLog("Не записался файл \(safeName) error: \(error)")
        }
    }
    
    func getImageFromDocumtest(with name: String) -> UIImage? {
        // Имя без `/` потому что нельзя нельзя сохранять файлы с `/`
        let safeName = name.replacingOccurrences(of: "/", with: ":")
        let fileUrl = filesDirectory.appendingPathComponent(safeName)
        let image = UIImage(contentsOfFile: fileUrl.path)
        return image
    }
    
}
