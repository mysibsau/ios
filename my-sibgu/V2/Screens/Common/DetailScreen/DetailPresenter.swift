//
//  DetailPresenter.swift
//  my-sibgu
//
//  Created by Artem Rylov on 15.08.2021.
//

import Foundation

protocol DetailPresenter: AnyObject {
    
    var detailViewController: DetailViewController? { get set }
    func start()
}

extension DetailPresenter {
    
    func hideAllElements() {
        detailViewController?.personImageView.isHidden = true
        detailViewController?.separateLine.isHidden = true
    }
}
