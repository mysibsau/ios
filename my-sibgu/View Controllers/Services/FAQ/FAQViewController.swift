//
//  FAQViewController.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import UIKit

class FAQViewController: UIViewController {
    
    private var faqs: [FAQResponse] = []

    // MARK: - Private UI
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let addQuestionButton = UIButton()
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let alertView = AlertView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        stackView.backgroundColor = .clear
        scrollView.backgroundColor = .clear
        
        setupNavBar()
        
        setupScrollView()
        setupStackView()
        
        if UserService().getCurrUser() != nil {
            setupAddQeustionButton()
        }
        
        setFaq()
        
        scrollView.subviews.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setLeftTitle(title: "FAQ")
    }
    
    @objc
    private func updateText() {
        let tableName = "FAQ"
        
        self.navigationItem.setLeftTitle(title: "nav.bar.title".localized(using: tableName))
        addQuestionButton.setTitle("ask.another.question".localized(using: tableName), for: .normal)
    }
    
    private func setFaq() {
        addQuestionButton.isHidden = true
        startActivityIndicator()
        GetModelsService.shared.loadAndStoreIfPossible(
            FAQListRequest(),
            deleteActionBeforeWriting: nil,
            completion: { faqs in
                DispatchQueue.main.async {
                    guard let faqs = faqs else {
                        self.stopActivityIndicator()
                        self.showNetworkAlert()
                        return
                    }
                    faqs.sorted { $0.views > $1.views }.forEach { faq in
                        let v = FAQView(faq: faq)
                        v.delegate = self
                        self.stackView.addArrangedSubview(v)
                    }
                    self.stopActivityIndicator()
                    self.addQuestionButton.isHidden = false
                }
            })
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
            make.width.equalTo(scrollView)
        }
    }
    
    private func setupAddQeustionButton() {
        addQuestionButton.backgroundColor = UIColor.Pallete.content
        addQuestionButton.setTitle("Задать другой вопрос", for: .normal)
        addQuestionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        addQuestionButton.setTitleColor(UIColor.Pallete.sibsuBlue, for: .normal)
        addQuestionButton.layer.cornerRadius = 15
        addQuestionButton.makeShadow()
        addQuestionButton.makeBorder()
        
        scrollView.addSubview(addQuestionButton)
        addQuestionButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        addQuestionButton.addTarget(self, action: #selector(didTapAddQuestionButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapAddQuestionButton() {
        present(AskQuestionViewController(), animated: true, completion: nil)
    }
    
}

extension FAQViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        addQuestionButton.makeBorder()
        addQuestionButton.makeShadow()
    }
    
}

extension FAQViewController: FAQViewDelegate {
    
    func didTapToShowInfoOnQuestion(with id: Int) {
        RequestServise.shared.perform(FAQViewRequest(faqID: id), completion: { _ in })
    }
}


extension FAQViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
    
}

extension FAQViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
    
}
