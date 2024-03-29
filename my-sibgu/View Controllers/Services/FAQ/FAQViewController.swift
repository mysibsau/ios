//
//  FAQViewController.swift
//  my-sibgu
//
//  Created by art-off on 03.02.2021.
//

import UIKit

class FAQViewController: UIViewController {
    
    enum Mode {
        case faq
        case myQuestions
    }
    
    var mode: Mode = .faq
    
    private var faqs: [FAQResponse] = []

    // MARK: - Private UI
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let alertView = AlertView()
    
    private let dontExistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.Pallete.gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        stackView.backgroundColor = .clear
        scrollView.backgroundColor = .clear
        
        setupNavBar()
        
        setupScrollView()
        setupStackView()
        
        if UserService().getCurrUser() != nil && mode == .faq {
            setupAddQeustionButton()
        }
        
        setFaq()
        
        scrollView.subviews.last?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
    }
    
    private func setFaq() {
        startActivityIndicator()
        
        switch mode {
        case .faq:
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
                    }
                })
        case .myQuestions:
            GetModelsService.shared.loadAndStoreIfPossible(
                FAQMyListRequest(),
                deleteActionBeforeWriting: nil,
                completion: { faqs in
                    DispatchQueue.main.async {
                        guard let faqs = faqs else {
                            self.stopActivityIndicator()
                            self.showNetworkAlert()
                            return
                        }
                        
                        guard !faqs.isEmpty else {
                            self.showEmplyLabel()
                            self.stopActivityIndicator()
                            return
                        }
                        
                        faqs.sorted { $0.createDate > $1.createDate }.forEach { faq in
                            let v = FAQView(faq: faq)
                            v.delegate = self
                            self.stackView.addArrangedSubview(v)
                        }
                        self.stopActivityIndicator()
                    }
                })
        }
    }
    
    private func showEmplyLabel() {
        if !self.view.subviews.contains(self.dontExistLabel) {
            self.view.addSubview(self.dontExistLabel)
            self.dontExistLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(10)
                make.centerY.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
        dontExistLabel.text = "У вас нет вопросов, либо на них еще не успели ответить"
        dontExistLabel.isHidden = false
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
        navigationItem.rightBarButtonItem = .init(image: .init(systemName: "square.and.pencil"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapAddQuestionButton))
    }
    
    @objc
    private func didTapAddQuestionButton() {
        present(AskQuestionViewController(), animated: true, completion: nil)
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
