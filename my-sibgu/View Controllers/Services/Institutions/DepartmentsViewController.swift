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
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        stackView.backgroundColor = .clear
        scrollView.backgroundColor = .clear
        
        setupScrollView()
        setupTitleLabel()
        setupStackView()
        
        for department in departments {
            let v = DepartmentView(department: department)
            stackView.addArrangedSubview(v)
        }
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText() {
        let tableName = "Institutes"
        
        titleLabel.text = "departments".localized(using: tableName)
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
