//
//  AttestaionViewController.swift
//  my-sibgu
//
//  Created by art-off on 19.02.2021.
//

import UIKit

class AttestaionViewController: UIViewController {
    
    private var attestationItems: [AttestationItem]!
    
    private let userService = UserService()
    
    private let activityIndicatorView = UIActivityIndicatorView()
    private let alertView = AlertView()
    
    // MARK: - Private UI
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        setupScrollView()
        
        setupStackView()
        
        loadAttestation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Setup Views
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setLeftTitle(title: "nav.bar.title".localized(using: "Attestation"))
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
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(scrollView)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView)
        }
    }
    
    private func loadAttestation() {
        startActivityIndicator()
        userService.getAttestation { attestationItems in
            guard let attestationItems = attestationItems else {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.showNetworkAlert()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                self.attestationItems = attestationItems
                self.set(attestationItems: attestationItems)
            }
        }
    }
    
    private func set(attestationItems: [AttestationItem]) {
        for item in attestationItems {
            let itemView = subjectSegment(item: item)
            stackView.addArrangedSubview(itemView)
        }
    }
    
    private func subjectSegment(item: AttestationItem) -> UIView {
        let view = UIView()
        
        // Name label
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLabel.textColor = UIColor.Pallete.sibsuBlue
        
        let attNameLabel = NSMutableAttributedString(string: "\(item.name) (\(item.type))")
        attNameLabel.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: NSRange(location: item.name.count, length: item.type.count + 3))
        nameLabel.attributedText = attNameLabel
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        // Separate line
        let separateView = UIView()
        separateView.backgroundColor = UIColor.Pallete.gray
        
        view.addSubview(separateView)
        separateView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        // Attestation stack
        let attestationStackView = UIStackView()
        attestationStackView.axis = .horizontal
        attestationStackView.distribution = .fillEqually
        
        attestationStackView.addArrangedSubview(attestationModuleView(number: "I", score: item.att1))
        attestationStackView.addArrangedSubview(attestationModuleView(number: "II", score: item.att2))
        attestationStackView.addArrangedSubview(attestationModuleView(number: "III", score: item.att3))
        
        view.addSubview(attestationStackView)
        attestationStackView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        
        
        view.backgroundColor = UIColor.Pallete.content
        view.layer.cornerRadius = 10
        
        view.makeShadow()
        view.makeBorder()
        
        return view
    }
    
    private func attestationModuleView(number: String, score: String) -> UIView {
        let view = UIView()
        
        // Number label
        let numberLabel = UILabel()
        numberLabel.text = number
        numberLabel.textColor = UIColor.Pallete.gray
        numberLabel.textAlignment = .center
        
        view.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        // Score label
        let scoreLabel = UILabel()
        scoreLabel.text = score
        scoreLabel.textAlignment = .center
        
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        return view
    }
    
}

extension AttestaionViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        activityIndicatorView
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        view
    }
    
}

extension AttestaionViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        view
    }
    
    func alertingAlertView() -> AlertView {
        alertView
    }
    
}

