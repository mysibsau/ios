//
//  StartViewController.swift
//  my-sibgu
//
//  Created by art-off on 13.02.2021.
//

import UIKit

class StartViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.text = "welcome".localized(using: "Trips")
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "main_logo")
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.text = "Мой СибГУ"
        return label
    }()
    
    private let letsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "lets.tell".localized(using: "Trips")
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Pallete.background

        setupLogoAndAppName()
        setupWelcomeLabel()
        setupLetsLabel()
    }
    
    private func setupLogoAndAppName() {
        view.addSubview(logoImageView)
        view.addSubview(appNameLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-60)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(100)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(10)
            make.centerY.equalTo(logoImageView)
        }
    }
    
    private func setupWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(logoImageView.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupLetsLabel() {
        view.addSubview(letsLabel)
        letsLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

}
