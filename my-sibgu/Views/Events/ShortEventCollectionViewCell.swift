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
    
    
    // MARK: - UI Components -
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()

    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
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
        
        readMoreOrLessButton.addTarget(self, action: #selector(readMoreOrLessButtonAction), for: .touchUpInside)
        
//        self.layoutSubviews()
//        print("1", textLabel.contentSize, textLabel.frame.size)
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
    func set(mode: EventCellMode, image: UIImage?, text: String?) {
        set(mode: mode)
        textLabel.text = text
        imageView.image = image
        
        if let image = image {
            let width = self.width.constant
            // я хз почему это работает, но оно дает нужную высоту по такой формуле ... УЖС
            let height = floor((image.size.height * width) / image.size.width) * 0.99
            
            imageView.snp.updateConstraints { update in
                update.height.equalTo(height)
            }
        }
    }
    
    func set(mode: EventCellMode) {
        self.mode = mode
        
        if mode == .short {
            textLabel.numberOfLines = 1
            readMoreOrLessButton.setTitle("[Читать далее]", for: .normal)
        } else if mode == .long {
            textLabel.numberOfLines = 0
            readMoreOrLessButton.setTitle("[Скрыть]", for: .normal)
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
    
}
