//
//  VacancyViewController.swift
//  my-sibgu
//
//  Created by art-off on 06.02.2021.
//

import UIKit

class VacancyViewController: UIViewController {
    
    var vacancy: Vacancy!
    
    // MARK: - Private UI
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    
    convenience init(vacancy: Vacancy) {
        self.init()
        self.vacancy = vacancy
        set(vacancy: vacancy)
    }
    
    // MARK: - Life Circle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Pallete.background
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        
        setupScrollView()
        setupStackView()
    }
    
    // MARK: - Setup Views
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setLeftTitle(title: "nav.bar.title".localized(using: "Work"))
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        // убираем полосы прокрутки
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        // настраиваем свойства StackView
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(scrollView)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView)
        }
    }
    
    private func set(vacancy: Vacancy) {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = UIColor.Pallete.gray
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.text = vacancy.name
        stackView.addArrangedSubview(nameLabel)
        
        let separateView = UIView()
        separateView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        separateView.backgroundColor = .clear
        stackView.addArrangedSubview(separateView)
        
        if let company = vacancy.company {
            let titleBodyView = TitleBodyView(title: "Компания", body: company)
            stackView.addArrangedSubview(titleBodyView)
        }
        
        if let duties = vacancy.duties {
            let titleBodyView = TitleBodyView(title: "Обязанности", body: duties)
            stackView.addArrangedSubview(titleBodyView)
        }
        
        if let requirements = vacancy.requirements {
            let titleBodyView = TitleBodyView(title: "Требования", body: requirements)
            stackView.addArrangedSubview(titleBodyView)
        }
        
        if let conditions = vacancy.conditions {
            let titleBodyView = TitleBodyView(title: "Условия", body: conditions)
            stackView.addArrangedSubview(titleBodyView)
        }
        
        if let schedule = vacancy.schedule {
            let titleBodyView = TitleBodyView(title: "График работы", body: schedule)
            stackView.addArrangedSubview(titleBodyView)
        }
        
        if let salary = vacancy.salary {
            let titleBodyView = TitleBodyView(title: "Заработная плата", body: salary)
            stackView.addArrangedSubview(titleBodyView)
        }
        
        if let address = vacancy.address {
            let titleBodyView = TitleBodyView(title: "Адрес", body: address)
            stackView.addArrangedSubview(titleBodyView)
        }
        
        if let addInfo = vacancy.addInfo {
            let titleBodyView = TitleBodyView(title: "Доп. информация", body: addInfo)
            stackView.addArrangedSubview(titleBodyView)
        }
        
        if let contacts = vacancy.contacts {
            let titleBodyView = TitleBodyView(title: "Контакты", body: contacts)
            stackView.addArrangedSubview(titleBodyView)
        }
        
        if let date = vacancy.publicationDate {
            let titleBodyView = TitleBodyView(title: "Дата публикации", body: date)
            stackView.addArrangedSubview(titleBodyView)
        }
    }

}
