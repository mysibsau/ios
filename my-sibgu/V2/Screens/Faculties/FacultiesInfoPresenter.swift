//
//  FacultiesInfoPresenter.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.10.2021.
//

import UIKit

class FacultiesInfoPresenter: DetailPresenter {
    
    var detailViewController: DetailViewController?
    
    var general: FaculityGeneral?
    var facultiets: [Faculity] = []
    
    func getStoreViewModel() -> DetailViewModel? {
        if UserService().getCurrUser() != nil {
            setupAddQeustionButton()
        }
        detailViewController?.navigationItem.setLeftTitle(title: "art".localized(using: "StudentsCollection"))
        let facultiets = GetModelsService.shared.getFromStore(type: Faculity.self)
        guard let general = GetModelsService.shared.getFromStore(type: FaculityGeneral.self).first,
              !facultiets.isEmpty
        else { return nil }
        self.facultiets = facultiets
        self.general = general
        return viewModel(general: general,
                         faculitys: self.facultiets)
    }
    
    func startLoading() {
        guard let detailViewController = detailViewController else { return }
        if facultiets.isEmpty || general == nil {
            DispatchQueue.main.async {
                self.hideAllElements()
                detailViewController.startActivityIndicator()
            }
        }
        
        GetModelsService.shared.loadAndStoreIfPossible(
            FaculityGeneralRequest(), FaculityRequest(),
            deleteActionBeforeWriting: {
                DatabaseManager.shared.deleteAll(RFaculityGeneral.self)
                DatabaseManager.shared.deleteAll(RFaculity.self)
            }) { general, fList in
            guard let general = general, let fList = fList else {
                DispatchQueue.main.async {
                    detailViewController.stopActivityIndicator()
                    detailViewController.showNetworkAlert()
                }
                return
            }
            detailViewController.stopActivityIndicator()
            self.set(general: general, faculties: fList)
        }
    }
    
    private func set(general: FaculityGeneral, faculties: [Faculity]) {
        DispatchQueue.main.async {
            guard self.facultiets != faculties || self.general != general else { return }
            self.general = general
            self.facultiets = faculties
            self.detailViewController?.setupViewModel(
                viewModel: self.viewModel(general: general, faculitys: faculties))
        }
    }
    
    private func viewModel(general: FaculityGeneral,
                           faculitys: [Faculity]) -> DetailViewModel {
        AnyDetailViewModel(
            navigationTitle: "sdo".localized(using: "StudentsCollection"),
            backgroundImage: .init(type: .url(general.logo), imageContentMode: .scaleAspectFill, imageHeightMultiply: 0.15),
            foregroundImage: .init(type: .hide),
            content: { viewController in
                let tn = "Person"
                
                let groupsContent = faculitys
                    .sorted { $0.id < $1.id }
                    .map { art in
                        DetailModel.Content.cornerImageWithText(
                            .init(text: art.name,
                                  imageUrl: art.logo,
                                  action: { self.openDetailScreen(faculty: art) }))
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
                
                var contactsGroup: [DetailModel.Content] = []
                general.contacts.let { cont in
                    contactsGroup.append(.textView(.init(text: cont, tappable: true)))
                }
                
                return [
                    .nameView(general.name),
                    .title("about".localized(using: tn)),
                    .textView(.init(text: general.description))
                ] + instaVkLink + contactsGroup + [
                    .title("faculties".localized(using: tn))
                ] + groupsContent
            })
    }
    
    private func openDetailScreen(faculty: Faculity) {
        detailViewController?.navigationController?.pushViewController(
            DetailViewController(viewModel: faculty), animated: true)
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
        vc.theme = "faculties"
        detailViewController?.present(vc, animated: true, completion: nil)
    }
}

extension Faculity: DetailViewModel {

    var navigationTitle: String? { name }

    var backgroundImage: DetailModel.Image { .init(type: .url(logo), imageContentMode: .scaleAspectFill, imageHeightMultiply: 0.5) }
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
        
        var contactsGroup: [DetailModel.Content] = []
        contacts.let { cont in
            contactsGroup.append(.textView(.init(text: cont, tappable: true)))
        }

        return [
            .title("about".localized(using: tn)),
            .textView(.init(text: description))
        ] + instaVkLink + [
            .title("contacts".localized(using: tn))
        ] + contactsGroup + [
            .button(.init(imageName: "add_circle", text: "join.to".localized(using: tn), action: {
                let vc = JoinToFacultieViewController()
                vc.unionId = id
                viewController.present(vc, animated: true)
            }))
        ]
    }
}
