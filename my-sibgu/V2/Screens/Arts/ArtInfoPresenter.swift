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
            navigationTitle: "Творчество",
            backgroundImage: .init(type: .url(general.logo)),
            foregroundImage: .init(type: .hide),
            content: { viewController in
                return arts
                    .sorted { $0.id < $1.id }
                    .map { DetailModel.Content.title($0.name) }
            })
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
