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

    let textLabel: TappableLabel = {
        let label = TappableLabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
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
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        imageView.layer.cornerRadius = 15
//        imageView.backgroundColor = .purple
        
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
        contentView.layer.cornerRadius = 15
        
        readMoreOrLessButton.addTarget(self, action: #selector(readMoreOrLessButtonAction), for: .touchUpInside)
        textLabel.makeTappable()
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
        
        if let text = text {
            let result = text.attributedStringWithLinkAndLinkRangesWithUrl()
            let atrStr = result.0
            rangesAndUrls = result.1
            textLabel.attributedText = atrStr
            textLabel.onCharacterTapped = { label, index in
                for (range, url) in self.rangesAndUrls {
                    if range.contains(index) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        } else {
            textLabel.attributedText = nil
        }
        
        imageView.image = image
        
        if let image = image {
            let width = self.width.constant
            // я хз почему это работает, но оно дает нужную высоту по такой формуле ... УЖС
            let height = floor((image.size.height * width) / image.size.width)// * 0.99
            
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
//
//    @objc private func labelTapped(gesture: UITapGestureRecognizer) {
//        let tapLocation = gesture.location(in: textLabel)
//        let index = textLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
//        print(index, rangesAndUrls)
//        for (range, url) in rangesAndUrls {
//            if checkRange(range, contain: index) {
//                print(url)
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url)
//                }
//                return
//            }
//        }
        
//        // set up the text engine
//        let layoutManager = NSLayoutManager()
//        let textContainer = NSTextContainer(size: .zero)
//        let textStorage = NSTextStorage(attributedString: textLabel.attributedText!)
//
//        // copy over properties from the label
//        // assuming left aligned text, might need further adjustments for other alignments
//        textContainer.lineFragmentPadding = 0
//        textContainer.lineBreakMode = textLabel.lineBreakMode
//        textContainer.maximumNumberOfLines = textLabel.numberOfLines
//        let labelSize = textLabel.bounds.size
//        textContainer.size = labelSize
//
//        // hook up the text engine
//        layoutManager.addTextContainer(textContainer)
//        textStorage.addLayoutManager(layoutManager)
//
//        // adjust for the layout manager's geometry (not sure exactly how this works but it's required)
//        let locationOfTouchInLabel = gesture.location(in: textLabel)
//        let textBoundingBox = layoutManager.usedRect(for: textContainer)
//        let textContainerOffset = CGPoint(
//            x: labelSize.width/2 - textBoundingBox.midX,
//            y: labelSize.height/2 - textBoundingBox.midY
//        )
//        let locationOfTouchInTextContainer = CGPoint(
//            x: locationOfTouchInLabel.x - textContainerOffset.x,
//            y: locationOfTouchInLabel.y - textContainerOffset.y
//        )
//
//        print(locationOfTouchInTextContainer)
//
//        // actually perform the check to get the index, accounting for multiple lines
//        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//
//        for (range, url) in rangesAndUrls {
//            if checkRange(range, contain: indexOfCharacter) {
//                print(url)
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url)
//                }
//                return
//            }
//        }
        
//        print(indexOfCharacter)
//
//        // get the attributes at the index
//        let attributes = textLabel.attributedText!.attributes(at: indexOfCharacter, effectiveRange: nil)
//
//        // use `.attachment` instead of `.link` so you can bring your own styling
//        if let url = attributes[.link] as? URL {
//             UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
    
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
    
}
