//
//  MarksViewController.swift
//  my-sibgu
//
//  Created by art-off on 18.02.2021.
//

import UIKit

class MarksViewController: UIViewController {
    
    private var marks: [Marks]!
    
    private let userService = UserService()
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let alertView = AlertView()
    
    // MARK: - Private UI
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
//    private let borderColor = UIColor.Pallete.border
//    private let shadowColor = UIColor.Pallete.shadow
    
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        setupScrollView()
        
        setupStackView()
        
        loadMarks()
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
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 20, right: 5)
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(scrollView)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView)
        }
    }
    
    private func loadMarks() {
        print(UIColor.Pallete.border.toHexString())
        
        startActivityIndicator()
        userService.getMarks { marks in
            guard let marks = marks else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.showNetworkAlert()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                self.marks = marks
                self.set(marks: marks)
            }
        }
        
        print(UIColor.Pallete.border.toHexString())
    }
    
    private func set(marks: [Marks]) {
        
        let sortedMarks = marks.sorted(by: { $0.term < $1.term })
        
        for itemMarks in sortedMarks {
            let segment = termMarksSegmetn(termMarks: itemMarks.items)
            stackView.addArrangedSubview(segment)
        }
    }
    
    private func termMarksSegmetn(termMarks: [TermMarks]) -> UIView {
        let termStackView = UIStackView()
        termStackView.axis = .vertical
        termStackView.spacing = 0
        termStackView.clipsToBounds = true
        
        for (index, item) in termMarks.enumerated() {
            let itemView = markItem(name: item.name, type: item.type, mark: item.mark)
            termStackView.addArrangedSubview(itemView)
            
            if index < termMarks.count - 1 {
                let separateView = UIView()
                separateView.snp.makeConstraints { make in
                    make.height.equalTo(1)
                }
                separateView.backgroundColor = .red //UIColor.Pallete.gray
                termStackView.addArrangedSubview(separateView)
            }
        }
        
        let view = UIView()
        view.addSubview(termStackView)
        termStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.backgroundColor = UIColor.Pallete.content
        
        view.layer.cornerRadius = 10
        
        view.makeBorder()
        view.makeShadow()
        
        return view
    }
    
    private func markItem(name: String, type: String, mark: String) -> UIView {
        let view = UIView()
        
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        let markLabel = UILabel()
        markLabel.numberOfLines = 0
        markLabel.lineBreakMode = .byWordWrapping
        markLabel.textAlignment = .right
        
        let attNameLabel = NSMutableAttributedString(string: "\(name) (\(type))")
        attNameLabel.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: NSRange(location: name.count, length: type.count + 3))
        nameLabel.attributedText = attNameLabel
        markLabel.text = mark
        
        view.addSubview(nameLabel)
        view.addSubview(markLabel)
        
        markLabel.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.trailing.top.bottom.equalToSuperview().inset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(markLabel.snp.leading).offset(-10)
        }
        
        return view
    }

}

extension MarksViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        stackView.removeAllArrangedSubviews()
        set(marks: self.marks)
    }
    
}

extension MarksViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
    
}

extension MarksViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
    
}

