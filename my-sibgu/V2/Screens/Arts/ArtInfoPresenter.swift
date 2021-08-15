//
//  ArtInfoPresenter.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.08.2021.
//

import UIKit

class ArtInfoPresenter: DetailPresenter {
    
    var detailViewController: DetailViewController?
    
    var arts: [ArtAssociation] = []
    
    func start() {
        hideAllElements()
        
        detailViewController?.startActivityIndicator()
        set(arts: GetModelsService.shared.getFromStore(type: ArtAssociation.self))
        detailViewController?.stopActivityIndicator()
    }
    
    private func set(arts: [ArtAssociation]) {
        guard self.arts != arts else { return }
        
        DispatchQueue.main.async {
            self.detailViewController?.setupViewModel(
                viewModel: AnyDetailViewModel(
                    navigationTitle: "Hello",
                    backgroundImage: .init(type: .local("back_main_logo")),
                    foregroundImage: .init(type: .hide),
                    content: { viewController in
                        return arts.map { DetailModel.Content.title($0.name) }
                    }))
        }
    }
}

extension ArtAssociation: DetailViewModel {
    
    var navigationTitle: String? { name }
    
    var backgroundImage: DetailModel.Image { .init(type: .url(logo)) }
    var foregroundImage: DetailModel.Image { .init(type: .hide) }
    
    func contentList(onPresenting viewController: UIViewController) -> [DetailModel.Content] {
        let tn = "Person"
        return [
            .title("about".localized(using: tn)),
            .textView(.init(text: description)),
            .title("contacts".localized(using: tn)),
            .textView(.init(text: contacts, tappable: true)),
            .button(.init(imageName: "add_circle", text: "join.to".localized(using: tn), action: {
                let vc = JoinToArtViewController()
                vc.artId = id
                viewController.present(vc, animated: true)
            }))
        ]
    }
}
