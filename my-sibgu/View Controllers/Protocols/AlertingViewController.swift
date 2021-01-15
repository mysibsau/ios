//
//  AlertingViewController.swift
//  my-sibgu
//
//  Created by art-off on 01.12.2020.
//

import UIKit

protocol AlertingViewController: class {
    
    // MARK: - Нужно реализовать
    func alertingSuperViewForDisplay() -> UIView
    func alertingAlertView() -> AlertView
    
    // MARK: - Реализованные
    func showAlert(withText alertText: String)
    func showNetworkAlert()
    
}

extension AlertingViewController {
    
    func showAlert(withText alertText: String) {
        let superViewForDisplay = alertingSuperViewForDisplay()
        let alertView = alertingAlertView()
        
        if !superViewForDisplay.subviews.contains(alertView) {
            superViewForDisplay.addSubview(alertView)

            alertView.translatesAutoresizingMaskIntoConstraints = false
            alertView.centerYAnchor.constraint(equalTo: superViewForDisplay.safeAreaLayoutGuide.centerYAnchor).isActive = true
            alertView.centerXAnchor.constraint(equalTo: superViewForDisplay.safeAreaLayoutGuide.centerXAnchor).isActive = true
        }

        alertView.alertLabel.text = alertText
        alertView.hideWithAnimation()
    }

    func showNetworkAlert() {
        showAlert(withText: "Проблемы с сервером")
    }
    
}
