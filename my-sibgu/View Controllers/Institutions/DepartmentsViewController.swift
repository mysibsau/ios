//
//  DepartmentsViewController.swift
//  my-sibgu
//
//  Created by art-off on 28.12.2020.
//

import UIKit

class DepartmentsViewController: UIViewController {
    
    var departments: [Institute.Department]!

    // MARK: - Private UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Colors.sibsuBlue
        label.text = "Кафедры"
        return label
    }()
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        setupScrollView()
        setupTitleLabel()
        setupStackView()
        
//        let v1 = DepartmentView(department: Institute.Department(name: "dep1", headDepartmentName: "dep1name", address: "dep1adress", phone: "dep1phone", email: "dep1email"))
//        let v2 = DepartmentView(department: Institute.Department(name: "dep2", headDepartmentName: "dep1name", address: "dep1adress", phone: "dep1phone", email: "dep1email"))
//        let v3 = DepartmentView(department: Institute.Department(name: "dep3", headDepartmentName: "dep1name", address: "dep1adress", phone: "dep1phone", email: "dep1email"))
//        let v4 = DepartmentView(department: Institute.Department(name: "dep4", headDepartmentName: "dep1name", address: "dep1adress", phone: "dep1phone", email: "dep1email"))
//        let v5 = DepartmentView(department: Institute.Department(name: "dep5", headDepartmentName: "dep1name", address: "dep1adress", phone: "dep1phone", email: "dep1email"))
//        
//        stackView.addArrangedSubview(v1)
//        stackView.addArrangedSubview(v2)
//        stackView.addArrangedSubview(v3)
//        stackView.addArrangedSubview(v4)
//        stackView.addArrangedSubview(v5)
        
        for department in departments {
            let v = DepartmentView(department: department)
            stackView.addArrangedSubview(v)
        }
    }
    
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Институты")
    }
    
    
    // MARK: - Setup Views
    private func setupScrollView() {
        view.addSubview(scrollView)
        // убираем полосы прокрутки
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTitleLabel() {
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    private func setupStackView() {
        // настраиваем свойства StackView
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(scrollView)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView)
        }
    }
    
}
