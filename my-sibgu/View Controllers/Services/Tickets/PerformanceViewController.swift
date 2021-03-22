//
//  PerformanceViewController.swift
//  my-sibgu
//
//  Created by art-off on 03.03.2021.
//

import UIKit

class PerformanceViewController: UIViewController {
    
    var performance: Performance!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    
    private let backgroupndImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.Pallete.white
        imageView.clipsToBounds = true
        return imageView
    }()
    private let separateLine = UIView()
    
    // Нижняя часть
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
    
    
    // В этот инициализатор буду пихать потом мероприятие
    convenience init(performance: Performance) {
        self.init()
        self.performance = performance
        
        backgroupndImageView.image = UIImage(named: "back_main_logo")
        
        addLabel(text: "Название")
        addNameView(name: performance.name)
        
        addLabel(text: "Описание")
        addTextView(text: performance.about)
        
        addLabel(text: "Театр")
        addTextView(text: performance.theatre)
        
        addButton(text: "Забранировать билет", action: {
            let vc = TicketDatesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        setupScrollView()

        setupBackgroundImage()
        setupSepareteLine()

        setupStackView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText() {
        let tableName = "Histrionics"
        
        stackView.removeAllArrangedSubviews()
        
        
        
//        if let soviet = person as? Institute.Soviet {
//            // add views
//            addLabel(text: "soviet.head".localized(using: tableName))
//            addNameView(name: soviet.leaderName)
//            addView(text: soviet.address, imageName: "place")
//            if let email = soviet.email {
//                addView(text: email, imageName: "email")
//            }
//            if let phone = soviet.phone {
//                addButton(text: phone, imageName: "phone", action: {
//                    guard let url = URL(string: "tel://\(phone.removingWhitespaces())") else { return }
//                    if UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url)
//                    }
//                })
//            }
//        }
    }
    
    // MARK: - Setup Views
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setLeftTitle(title: "nav.bar.title".localized(using: "Tickets"))
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
        separateLine.backgroundColor = UIColor.Pallete.gray
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            // В спорт нет круглого изображения
            make.top.equalTo(separateLine.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    // MARK: - Add Views
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
    
    private func addButton(text: String, action: @escaping () -> Void) {
        let b = LabelButton(text: text, action: action)
        b.backgroundColor = UIColor.Pallete.sibsuBlue
        b.centerLabel.textColor = UIColor.Pallete.white
        b.centerLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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
