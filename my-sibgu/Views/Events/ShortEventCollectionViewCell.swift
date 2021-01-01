//
//  ShortEventCollectionViewCell.swift
//  my-sibgu
//
//  Created by art-off on 30.12.2020.
//

import UIKit
import SnapKit

enum EventCellMode {
    case short
    case long
}

class ShortEventCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ShortEventCell"
    
    
    private var mode: EventCellMode = .short
    
    
    // MARK: - UI Components -
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()

    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        return label
    }()
    
    let readMoreOrLessButton: UIButton = {
        let button = UIButton()
        button.setTitle("[Читать далее]", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Helper
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .systemBackground
        // не удаляй эту строчку
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(2)
            make.height.equalTo(10)
        }
        
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        
        contentView.addSubview(readMoreOrLessButton)
        readMoreOrLessButton.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview().inset(4)
            make.width.equalTo(200)
        }

        contentView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 4)
        contentView.layer.cornerRadius = 5
        
        self.layoutSubviews()
        print(textLabel.contentSize, textLabel.bounds.size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            update.height.equalTo(100)
        }
        
        imageView.image = nil
    }
    
    // MARK: - Setters -
    func set(image: UIImage?, text: String? = nil) {
        guard let image = image else {
            imageView.image = nil
            return
        }
        
        imageView.image = image
        
        self.layoutIfNeeded()
        
        let width = self.width.constant //UIScreen.main.bounds.width - 12 //self.imageView.frame.width
        // я хз почему это работает, но оно дает нужную высоту по такой формуле ... УЖС
        let height = floor((image.size.height * width) / image.size.width) * 0.99
        
        imageView.snp.updateConstraints { update in
            update.height.equalTo(height)
        }
        
        self.layoutIfNeeded()
        contentView.layoutIfNeeded()
        imageView.layoutIfNeeded()
        textLabel.layoutIfNeeded()
        readMoreOrLessButton.layoutIfNeeded()
    }
    
    func set(mode: EventCellMode) {
        self.mode = mode
        
        if mode == .short {
            readMoreOrLessButton.setTitle("[Читать далее]", for: .normal)
        } else if mode == .long {
            readMoreOrLessButton.setTitle("[Скрыть]", for: .normal)
        }
    }
    
}
