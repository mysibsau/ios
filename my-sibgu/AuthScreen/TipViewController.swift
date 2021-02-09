//
//  TipViewController.swift
//  my-sibgu
//
//  Created by art-off on 08.02.2021.
//

import UIKit

class TipViewController: UIViewController {
    
    private let contentView = UIView()
    private let imageView: UIImageView = {
        let imageVIew = UIImageView()
        imageVIew.contentMode = .scaleAspectFit
        return imageVIew
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor.Pallete.white
        return label
    }()
    let whatIsItTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let whatIsItLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    let whatIsItImageView: UIImageView = {
        let imageVIew = UIImageView()
        imageVIew.contentMode = .scaleAspectFit
        return imageVIew
    }()
    
    let howIsItTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let howIsItLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    let howIsItImageView: UIImageView = {
        let imageVIew = UIImageView()
        imageVIew.contentMode = .scaleAspectFit
        return imageVIew
    }()

    
    convenience init(titleText: String, whatIsItText: String, howIsItText: String, image: UIImage) {
        self.init()
        titleLabel.text = titleText
        whatIsItLabel.text = whatIsItText
        howIsItLabel.text = howIsItText
        imageView.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = UIColor.Pallete.background
        
        addTitleLabel()
        addContentView()
        addImage()
        
        whatIsItImageView.image = UIImage(systemName: "wand.and.stars")
        howIsItImageView.image = UIImage(systemName: "questionmark")
        
        whatIsItTitleLabel.text = "Что это такое?"
        howIsItTitleLabel.text = "Как это работает?"
    }
    
    private func addTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func addContentView() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(130)
            make.bottom.leading.trailing.equalToSuperview()
        }
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        // Add whatItIs
        contentView.addSubview(whatIsItTitleLabel)
        whatIsItTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(70)
            make.top.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(whatIsItLabel)
        whatIsItLabel.snp.makeConstraints { make in
            make.top.equalTo(whatIsItTitleLabel.snp.bottom)
            make.trailing.leading.equalTo(whatIsItTitleLabel)
        }
        
        contentView.addSubview(whatIsItImageView)
        whatIsItImageView.snp.makeConstraints { make in
            make.top.equalTo(whatIsItTitleLabel)
            make.leading.equalTo(15)
            make.size.equalTo(40)
        }
        
        // Add howItIs
        contentView.addSubview(howIsItTitleLabel)
        howIsItTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(70)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(whatIsItLabel.snp.bottom).offset(10)
        }
        
        contentView.addSubview(howIsItLabel)
        howIsItLabel.snp.makeConstraints { make in
            make.top.equalTo(howIsItTitleLabel.snp.bottom)
            make.trailing.leading.equalTo(howIsItTitleLabel)
        }
        
        contentView.addSubview(howIsItImageView)
        howIsItImageView.snp.makeConstraints { make in
            make.top.equalTo(howIsItTitleLabel)
            make.leading.equalTo(15)
            make.size.equalTo(40)
        }
    }
    
    private func addImage() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(contentView.snp.top).offset(-10)
            make.size.equalTo(85)
        }
//        imageView.image = UIImage(named: "restaurant")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.alpha = 0.6
    }

}
