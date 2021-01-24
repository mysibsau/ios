//
//  PersonViewController.swift
//  my-sibgu
//
//  Created by art-off on 05.12.2020.
//

import UIKit
import SnapKit

class PersonViewController: UIViewController {
    
    var person: Any?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    

    private let backgroupndImageView: BlurImageView = {
        let imageView = BlurImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        imageView.clipsToBounds = true
        return imageView
    }()
    private let separateLine = UIView()
    private let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    // Нижняя часть
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
    
    private let positionLabel = UILabel()
    
    
    convenience init(soviet: Institute.Soviet) {
        self.init()
        self.person = soviet
        updateText()
        // start loading image
        backgroupndImageView.blurRadius = 0
        backgroupndImageView.image = UIImage(named: "back_main_logo")
        personImageView.loadImage(at: soviet.imageUrl)
    }
    
    convenience init(director: Institute.Director) {
        self.init()
        self.person = director
        updateText()
        // Set image
        backgroupndImageView.blurRadius = 0
        backgroupndImageView.image = UIImage(named: "back_main_logo")
        personImageView.loadImage(at: director.imageUrl)
    }
    
    convenience init(union: Union) {
        self.init()
        self.person = union
        updateText()
        backgroupndImageView.loadImage(at: union.logoUrl)
        personImageView.loadImage(at: union.leaderPhotoUrl)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        
        setupScrollView()

        setupBackgroundImage()
        setupSepareteLine()
        setupDirectorImage()

        setupStackView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText() {
        let tableName = "Person"
        
        stackView.removeAllArrangedSubviews()
        
        if let soviet = person as? Institute.Soviet {
            // add views
            addLabel(text: "soviet.head".localized(using: tableName))
            addNameView(name: soviet.leaderName)
            addView(text: soviet.address, imageName: "place")
            if let email = soviet.email {
                addView(text: email, imageName: "email")
            }
            if let phone = soviet.phone {
                addButton(text: phone, imageName: "phone", action: {
                    guard let url = URL(string: "tel://\(phone.removingWhitespaces())") else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                })
            }
        } else if let director = person as? Institute.Director {
            // Add views
            addLabel(text: "director".localized(using: tableName))
            addNameView(name: director.name)
            addView(text: director.address, imageName: "place")
            addView(text: director.email, imageName: "email")
            addButton(text: director.phone, imageName: "phone", action: {
                guard let url = URL(string: "tel://\(director.phone.removingWhitespaces())") else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
        } else if let union = person as? Union {
            self.navigationItem.setCenterTitle(title: union.shortName ?? union.name)
            
            if let about = union.about {
                addLabel(text: "about".localized(using: tableName))
                addTextView(text: about)
            }
            if let leaderRank = union.leaderRank, !leaderRank.isEmpty {
                addLabel(text: leaderRank)
            } else {
                addLabel(text: "head".localized(using: tableName))
            }
            addView(text: union.address, imageName: "place")
            addButton(text: union.phone, imageName: "phone", action: {
                guard let url = URL(string: "tel://\(union.phone.removingWhitespaces())") else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
            addButton(text: "group.vk".localized(using: tableName), imageName: "vk", action: {
                if UIApplication.shared.canOpenURL(union.groupVkUrl) {
                    UIApplication.shared.open(union.groupVkUrl)
                }
            })
            if union.leaderPageVkUrl != nil {
                addButton(text: "join.to".localized(using: tableName), imageName: "add_circle", action: {
                    let vc = JoinToUnionViewController()
                    vc.unionId = union.id
                    self.present(vc, animated: true, completion: nil)
                })
            }
        }
    }
    
    // MARK: - Setup Views
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
//        self.navigationItem.setCenterTitle(title: "ИИТК")
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        // убираем полосы прокрутки
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view)
        }
    }
    
    private func setupBackgroundImage() {
        contentView.addSubview(backgroupndImageView)
        backgroupndImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.3)
        }
    }
    
    private func setupSepareteLine() {
        contentView.addSubview(separateLine)
        separateLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backgroupndImageView.snp.bottom)
            make.height.equalTo(3)
        }
        separateLine.backgroundColor = .gray
    }
    
    private func setupDirectorImage() {
        contentView.addSubview(personImageView)
        personImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.center.equalTo(separateLine)
        }
        
        personImageView.layer.cornerRadius = 75
        personImageView.layer.borderWidth = 2
        personImageView.layer.borderColor = UIColor.gray.cgColor
        personImageView.clipsToBounds = true
        personImageView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 4)
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(personImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func addLabel(text: String) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.sibsuBlue
        label.text = text
        addArrangedSubviewToStackView(view: label, additionalPading: 0)
    }
    
    private func addTextView(text: String) {
        let textView = CenterLabelView(text: text)
        textView.centerLabel.textAlignment = .left
        textView.centerLabel.font = UIFont.systemFont(ofSize: 16)
        addArrangedSubviewToStackView(view: textView, additionalPading: 0)
    }
    
    private func addNameView(name: String) {
        let nameView = CenterLabelView(text: name)
        addArrangedSubviewToStackView(view: nameView, additionalPading: 0)
    }
    
    private func addView(text: String, imageName: String) {
        let v = ImageAndLabelView(text: text, imageName: imageName)
        addArrangedSubviewToStackView(view: v, additionalPading: 0)
    }
    
    private func addButton(text: String, imageName: String, action: @escaping () -> Void) {
        let b = ImageAndLabelButton(text: text, imageName: imageName, action: action)
        addArrangedSubviewToStackView(view: b, additionalPading: 0)
    }
    
    
    private func addArrangedSubviewToStackView(view: UIView, additionalPading: Int) {
        let wrapView = UIView()
        wrapView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20 + additionalPading)
            make.top.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(wrapView)
    }

}
