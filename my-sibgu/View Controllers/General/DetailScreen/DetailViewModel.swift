//
//  DetailViewModel.swift
//  my-sibgu
//
//  Created by Artem Rylov on 08.08.2021.
//

import UIKit

protocol DetailViewModel {
    
    var navigationTitle: String? { get }
    
    var backgroundImage: DetailModel.Image { get }
    var foregroundImage: DetailModel.Image { get }
    
    func contentList(onPresenting viewController: UIViewController) -> [DetailModel.Content]
}

enum DetailModel {
    
    struct Image {
        let useBlur: Bool
        let type: ImageType
        
        init(type: ImageType, useBlur: Bool = false) {
            self.type = type
            self.useBlur = useBlur
        }
    }
    
    enum Content {
        case title(String),
             nameView(String),
             textView(TextViewModel),
             imageAndTextView(ImageAndTextViewModel),
             button(ButtonViewModel)
    }
    
    struct ImageAndTextViewModel {
        let imageName: String
        let text: String
    }
    
    struct ButtonViewModel {
        let imageName: String
        let text: String
        let action: () -> Void
    }
    
    struct TextViewModel {
        let tappable: Bool
        let text: String
        
        init(text: String, tappable: Bool = false) {
            self.text = text
            self.tappable = tappable
        }
    }
    
    enum ImageType: Equatable {
        case local(String),
             url(URL),
             hide
    }
}

extension DetailModel.Image {
    
    func setup(imageView: UIImageView) {
        if let blurImageView = imageView as? BlurImageView {
            blurImageView.blurRadius = useBlur ? 2 : 0
        }
        switch type {
        case .local(let name):
            imageView.image = .init(named: name)
        case .url(let url):
            imageView.loadImage(at: url)
        case .hide:
            imageView.isHidden = true
        }
    }
}
