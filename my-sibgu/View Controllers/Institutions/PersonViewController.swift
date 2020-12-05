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
    
    // Верхняя часть
    private let backgroupndImageView = UIImageView()
    private let separateLine = UIView()
    private let personImageView = UIImageView()
    
    // Нижняя часть
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
    
    private let positionLabel = UILabel()
//    private let nameView = CenterLabelView()
//    private let placeView = ImageAndLabelView()
    
    
    convenience init(soviet: Institute.Soviet) {
        self.init()
        self.person = soviet
    }
    
    convenience init(director: Institute.Director) {
        self.init()
        self.person = director
    }
    
    convenience init(union: Union) {
        self.init()
        self.person = union
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        
        setupScrollView()

        setupBackgroundImage()
        setupSepareteLine()
        setupDirectorImage()

        setupPositionLabel()

        setupStackView()
    }
    
    // MARK: - Setup Views
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setCenterTitle(title: "ИИТК") // ТУТ ПОМЕНЯТЬ НА ИНСТУТУТ
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        // убираем полосы прокрутки
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
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
        let image: UIImage? = nil
        backgroupndImageView.image = image
        
        contentView.addSubview(backgroupndImageView)
        backgroupndImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.3)
        }
        
        // пока нет фоточек будет цвет
        backgroupndImageView.backgroundColor = .green
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
        let image: UIImage? = nil
        personImageView.image = image
        
        contentView.addSubview(personImageView)
        personImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.center.equalTo(separateLine)
        }
        
        personImageView.layer.cornerRadius = 75
        personImageView.layer.borderWidth = 2
        personImageView.layer.borderColor = UIColor.gray.cgColor
        personImageView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 4)
        
        personImageView.backgroundColor = .red
    }
    
    private func setupPositionLabel() {
        contentView.addSubview(positionLabel)
        positionLabel.snp.makeConstraints { make in
            make.top.equalTo(personImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        positionLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        positionLabel.textColor = Colors.sibsuBlue
        
        positionLabel.text = "Директор института"
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(positionLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        addNameView(name: "Имя Фамилия Отчество")
        addView(text: "Hello ghbdtn t,fyf ye ,kz vse ze xorocho hehehe lol cheburek", imageName: "place")
        addView(text: "+7 (929) 333-84-54", imageName: "phone")
        addView(text: "tema2707@icloud.com", imageName: "email")
    }
    
    private func addNameView(name: String) {
        let nameView = CenterLabelView(text: name)
        addArrangedSubviewToStackView(view: nameView)
    }
    
    private func addView(text: String, imageName: String) {
        let v = ImageAndLabelView(text: text, imageName: imageName)
        addArrangedSubviewToStackView(view: v)
    }
    
    private func addArrangedSubviewToStackView(view: UIView) {
        let wrapView = UIView()
        wrapView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(wrapView)
    }

}
