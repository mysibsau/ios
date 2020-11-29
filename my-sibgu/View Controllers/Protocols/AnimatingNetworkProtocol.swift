//
//  AnimatingNetworkProtocol.swift
//  my-sibgu
//
//  Created by art-off on 28.11.2020.
//

import UIKit

protocol AnimatingNetworkProtocol {
    
    // MARK: - Нужно реализовать
    func animatingActivityIndicatorView() -> UIActivityIndicatorView
    func animatingSuperViewForDisplay() -> UIView
    
    // MARK: - Не нежно реализовывать
    func startActivityIndicator()
    func stopActivityIndicator()
    
}

extension AnimatingNetworkProtocol {
    
    func startActivityIndicator() {
        let superView = animatingSuperViewForDisplay()
        let adtivityIndicatorView = animatingActivityIndicatorView()
        if !superView.subviews.contains(adtivityIndicatorView) {
            superView.addSubview(adtivityIndicatorView)
            adtivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            adtivityIndicatorView.centerYAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.centerYAnchor).isActive = true
            adtivityIndicatorView.centerXAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        }
        
        adtivityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator() {
        let adtivityIndicatorView = animatingActivityIndicatorView()
        adtivityIndicatorView.stopAnimating()
    }
    
}
