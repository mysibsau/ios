//
//  DetailViewController.swift
//  my-sibgu
//
//  Created by art-off on 05.12.2020.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel?
    var presenter: DetailPresenter?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let alertView = AlertView()
    private let activityIndicatorView = UIActivityIndicatorView()
    

    let backgroupndImageView: BlurImageView = {
        let imageView = BlurImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.Pallete.white
        imageView.clipsToBounds = true
        return imageView
    }()
    let separateLine = UIView()
    let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.Pallete.content
        return imageView
    }()
    
    // Нижняя часть
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
    
    private let positionLabel = UILabel()
    
    init(presenter: DetailPresenter) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.presenter?.detailViewController = self
    }
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupViewModel(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewModel(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        setupStackView()
        separateLine.isHidden = false
        if let title = viewModel.navigationTitle {
            navigationItem.setCenterTitle(title: title)
        }
        viewModel.backgroundImage.setup(imageView: backgroupndImageView)
        viewModel.foregroundImage.setup(imageView: personImageView)
        updateText()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupNavBar()
        
        setupScrollView()

        setupBackgroundImage()
        setupSepareteLine()
        setupDirectorImage()

        setupStackView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
        
        presenter?.start()
    }
    
    @objc
    private func updateText() {
        guard let viewModel = viewModel else { return }
        
        stackView.removeAllArrangedSubviews()
        
        for contentItem in viewModel.contentList(onPresenting: self) {
            switch contentItem {
            case .title(let string):
                addLabel(text: string)
            case .nameView(let string):
                addNameView(name: string)
            case .textView(let model):
                addTextView(text: model.text, tappable: model.tappable)
            case .imageAndTextView(let model):
                addView(text: model.text, imageName: model.imageName)
            case .button(let model):
                addButton(text: model.text, imageName: model.imageName, action: model.action)
            case .cornerImageWithText(let model):
                addCornerImageWithTextView(text: model.text, imageUrl: model.imageUrl, action: model.action)
            }
        }
    }
    
    // MARK: - Setup Views
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
//        self.navigationItem.setCenterTitle(title: "ИИТК")
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
    
    private func setupDirectorImage() {
        contentView.addSubview(personImageView)
        personImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.center.equalTo(separateLine)
        }
        
        personImageView.layer.cornerRadius = 75
        personImageView.layer.borderWidth = 2
        personImageView.layer.borderColor = UIColor.Pallete.gray.cgColor
        personImageView.clipsToBounds = true
        personImageView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 4)
    }
    
    private func setupStackView() {
        if contentView.subviews.contains(stackView) {
            stackView.removeFromSuperview()
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            // В спорт нет круглого изображения
            if viewModel?.foregroundImage.type == .hide {
                make.top.equalTo(separateLine.snp.bottom).offset(30)
            } else {
                make.top.equalTo(personImageView.snp.bottom).offset(30)
            }
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func addLabel(text: String) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.Pallete.sibsuBlue
        label.text = text
        addArrangedSubviewToStackView(view: label, additionalPading: 0)
    }
    
    private func addTextView(text: String, tappable: Bool = false) {
        let textView = CenterLabelView(text: text, tappable: tappable)
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
    
    private func addCornerImageWithTextView(text: String, imageUrl: URL, action: @escaping () -> Void) {
        addArrangedSubviewToStackView(view: CornerImageWithTitleView(text: text, imageUrl: imageUrl, action: action))
    }
    
    
    private func addArrangedSubviewToStackView(view: UIView, additionalPading: Int = 0) {
        let wrapView = UIView()
        wrapView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20 + additionalPading)
            make.top.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(wrapView)
    }

}

extension DetailViewController: AlertingViewController, AnimatingNetworkProtocol {
    
    func alertingSuperViewForDisplay() -> UIView { view }
    func alertingAlertView() -> AlertView { alertView }
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView { activityIndicatorView }
    func animatingSuperViewForDisplay() -> UIView { view }
}
