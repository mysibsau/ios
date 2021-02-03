//
//  FAQViewController.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import UIKit

class FAQViewController: UIViewController {
    
    private var faqs: [FAQ] = []

    // MARK: - Private UI
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        stackView.backgroundColor = .clear
        scrollView.backgroundColor = .clear
        
        navigationItem.title = "Частые вопросы"
        
        setupScrollView()
        setupStackView()
        
        faqs = [
            FAQ(rank: 32, question: "32Как какать?", answer: "В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают."),
            FAQ(rank: 55, question: "55Как какать?", answer: "В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают."),
            FAQ(rank: 13, question: "13Как какать?", answer: "В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают."),
            FAQ(rank: 32, question: "32Как какать?", answer: "В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают."),
            FAQ(rank: 111, question: "111Как какать?", answer: "В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают."),
            FAQ(rank: 40, question: "40Как какать?", answer: "В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают. В нашем вузе не какают."),
        ]
        
        for faq in faqs.sorted(by: { $0.rank > $1.rank }) {
            let v = FAQView(faq: faq)
            stackView.addArrangedSubview(v)
        }
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText() {
        let tableName = "FAQ"
        
        navigationItem.title = "nav.bar.title".localized(using: tableName)
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
    
    private func setupStackView() {
        // настраиваем свойства StackView
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.trailing.equalTo(scrollView)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView)
        }
    }
    
}
