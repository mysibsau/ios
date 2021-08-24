//
//  ArtInfoPresenter.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.08.2021.
//

import UIKit

class ArtInfoPresenter: DetailPresenter {
    
    var detailViewController: DetailViewController?
    
    var general: ArtAssociationGeneral?
    var arts: [ArtAssociation] = []
    
    func getStoreViewModel() -> DetailViewModel? {
        if UserService().getCurrUser() != nil {
            setupAddQeustionButton()
        }
        detailViewController?.navigationItem.setLeftTitle(title: "art".localized(using: "StudentsCollection"))
        let arts = GetModelsService.shared.getFromStore(type: ArtAssociation.self)
        guard let general = GetModelsService.shared.getFromStore(type: ArtAssociationGeneral.self).first,
              !arts.isEmpty
        else { return nil }
        self.arts = arts
        self.general = general
        return viewModel(general: general,
                         arts: arts)
    }
    
    func startLoading() {
        guard let detailViewController = detailViewController else { return }
        if arts.isEmpty || general == nil {
            DispatchQueue.main.async {
                self.hideAllElements()
                detailViewController.startActivityIndicator()
            }
        }
        
        GetModelsService.shared.loadAndStoreIfPossible(
            ArtAssociationGeneralRequest(), ArtAssociationRequest(),
            deleteActionBeforeWriting: {
                DatabaseManager.shared.deleteAll(RArtAssociationGeneral.self)
                DatabaseManager.shared.deleteAll(RArtAssociation.self)
            }) { general, artsList in
            guard let general = general, let artsList = artsList else {
                DispatchQueue.main.async {
                    detailViewController.stopActivityIndicator()
                    detailViewController.showNetworkAlert()
                }
                return
            }
            detailViewController.stopActivityIndicator()
            self.set(general: general, arts: artsList)
        }
    }
    
    private func set(general: ArtAssociationGeneral, arts: [ArtAssociation]) {
        DispatchQueue.main.async {
            guard self.arts != arts || self.general != general else { return }
            self.general = general
            self.arts = arts
            self.detailViewController?.setupViewModel(
                viewModel: self.viewModel(general: general, arts: arts))
        }
    }
    
    private func viewModel(general: ArtAssociationGeneral,
                           arts: [ArtAssociation]) -> DetailViewModel {
        AnyDetailViewModel(
            navigationTitle: "art".localized(using: "StudentsCollection"),
            backgroundImage: .init(type: .url(general.logo)),
            foregroundImage: .init(type: .hide),
            content: { viewController in
                let tn = "Person"
                
                let groupsContent = arts
                    .sorted { $0.id < $1.id }
                    .map { art in
                        DetailModel.Content.cornerImageWithText(
                            .init(text: art.name,
                                  imageUrl: art.logo,
                                  action: { self.openDetailScreen(art: art) }))
                    }
                
                var instaVkLink: [DetailModel.Content] = []
                general.vkLink.let { link in
                    instaVkLink.append(.button(.init(imageName: "vk",
                                                     text: "link.vk".localized(using: tn),
                                                     action: { link.openIfCan() })))
                }
                general.instagramLink.let { link in
                    instaVkLink.append(.button(.init(imageName: "instagram",
                                                     text: "link.inst".localized(using: tn),
                                                     action: { link.openIfCan() })))
                }
                
                return [
                    .nameView(general.name),
                    .title("about".localized(using: tn)),
                    .textView(.init(text: general.description))
                ] + instaVkLink + [
                    .textView(.init(text: general.contacts, tappable: true)),
                    .title("groups".localized(using: tn))
                ] + groupsContent
            })
    }
    
    private func openDetailScreen(art: ArtAssociation) {
        detailViewController?.navigationController?.pushViewController(
            DetailViewController(viewModel: art), animated: true)
    }
    
    private func setupAddQeustionButton() {
        detailViewController?.navigationItem.rightBarButtonItem = .init(image: .init(systemName: "square.and.pencil"),
                                                                        style: .plain,
                                                                        target: self,
                                                                        action: #selector(didTapAddQuestionButton))
    }
    
    @objc
    private func didTapAddQuestionButton() {
        let vc = AskQuestionViewController()
        vc.theme = "ktc"
        detailViewController?.present(vc, animated: true, completion: nil)
    }
}

extension ArtAssociation: DetailViewModel {
    
    var navigationTitle: String? { name }
    
    var backgroundImage: DetailModel.Image { .init(type: .url(logo)) }
    var foregroundImage: DetailModel.Image { .init(type: .hide) }
    
    func contentList(onPresenting viewController: UIViewController) -> [DetailModel.Content] {
        let tn = "Person"
        
        var instaVkLink: [DetailModel.Content] = []
        vkLink.let { link in
            instaVkLink.append(.button(.init(imageName: "vk",
                                             text: "link.vk".localized(using: tn),
                                             action: { link.openIfCan() })))
        }
        instagramLink.let { link in
            instaVkLink.append(.button(.init(imageName: "instagram",
                                             text: "link.inst".localized(using: tn),
                                             action: { link.openIfCan() })))
        }
        
        return [
            .title("about".localized(using: tn)),
            .textView(.init(text: description))
        ] + instaVkLink + [
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
