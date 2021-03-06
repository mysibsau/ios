//
//  ShortEventCollectionViewCell.swift
//  my-sibgu
//
//  Created by art-off on 30.12.2020.
//

import UIKit
import SnapKit

class ShortEventCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ShortEventCell"
    
    var indexPath: IndexPath!
    var delegate: EventsCellDelegate?
    
    private var mode: EventCellMode = .short
    
    private var rangesAndUrls: [NSRange: URL] = [:]
    
    
    // MARK: - UI Components -
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()

    let textLabel: UrlTappableLabel = {
        let label = UrlTappableLabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let readMoreOrLessButton: UIButton = {
        let button = UIButton()
        button.setTitle("[Читать далее]", for: .normal)
        button.setTitleColor(UIColor.Pallete.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .leading
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Helper Constransts
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
//    private var textLabelBottomToSuperviewConstraint: Constraint?
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor.Pallete.content
        // не удаляй эту строчку
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = UIColor.Pallete.content
        
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(readMoreOrLessButton)
        readMoreOrLessButton.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.leading.bottom.equalToSuperview().inset(10)
            make.width.equalTo(200)
        }

//        contentView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 4)
        contentView.makeShadow()
        contentView.makeBorder()
        contentView.layer.cornerRadius = 15
        
        readMoreOrLessButton.addTarget(self, action: #selector(readMoreOrLessButtonAction), for: .touchUpInside)
//        textLabel.makeTappable()
        textLabel.makeUrlTappable()
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // для меня магия то, как работает эта строчка
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.snp.updateConstraints { update in
            update.height.equalTo(0)
        }
        
        imageView.image = nil
    }
    
    // MARK: - Setters -
    func set(mode: EventCellMode, image: Image?, text: String?) {
        set(mode: mode)
        
        if let text = text {
            textLabel.setTextWithUrls(text: text)
        } else {
            textLabel.attributedText = nil
        }
        
        if let image = image {
            let width = self.width.constant
            
            let height = floor((CGFloat(image.height) * width) / CGFloat(image.width))
            
            imageView.snp.updateConstraints { update in
                update.height.equalTo(height)
            }
            
            imageView.loadImage(at: image.url)
        }
        
        imageView.image = nil
    }
    
    func set(mode: EventCellMode) {
        self.mode = mode
        
        if mode == .short {
            textLabel.numberOfLines = 3
            textLabel.lineBreakMode = .byTruncatingTail
            updateText()
        } else if mode == .long {
            textLabel.numberOfLines = 0
            textLabel.lineBreakMode = .byWordWrapping
            updateText()
        }
    }
    
    // MARK: - Actions -
    @objc private func readMoreOrLessButtonAction() {
        if mode == .short {
            delegate?.setAndReload(cellMode: .long, at: indexPath)
        } else if mode == .long {
            delegate?.setAndReload(cellMode: .short, at: indexPath)
        }
    }
    
    @objc
    private func updateText() {
        let tableName = "Informing"
        
        if mode == .short {
            readMoreOrLessButton.setTitle("more".localized(using: tableName), for: .normal)
        } else if mode == .long {
            readMoreOrLessButton.setTitle("hide".localized(using: tableName), for: .normal)
        }
    }
    
}

extension ShortEventCollectionViewCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        contentView.makeShadow()
        contentView.makeBorder()
    }
    
}
