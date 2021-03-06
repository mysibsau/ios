//
//  UrlTappableLabel.swift
//  my-sibgu
//
//  Created by art-off on 06.03.2021.
//

import UIKit

class UrlTappableLabel: TappableLabel {
    
    private var rangesAndUrls: [NSRange: URL] = [:]
    
    var attributedTextWithUrl: NSAttributedString? {
        get { attributedText }
        set { updateUrlsAndAttributedText(newValue: newValue) }
    }
    
    func makeUrlTappable() {
        self.makeTappable()
        updateUrlsAndAttributedText(newValue: attributedTextWithUrl)
    }
    
    private func updateUrlsAndAttributedText(newValue: NSAttributedString?) {
        rangesAndUrls.removeAll()
        
        guard let newValue = newValue else { return }
        
        let mutAtrString = NSMutableAttributedString(attributedString: newValue)
        
        let linkUrls = mutAtrString.addAttributesWithLinkAndLinkRangesWithUrl()
        var emailUrls = mutAtrString.addAttributesWithEmailAndEmailRangesWithUrl()
        emailUrls.merge(dict: linkUrls)
        
        self.rangesAndUrls = emailUrls
        self.attributedText = mutAtrString
        onCharacterTapped = { _, index in
            for (range, url) in self.rangesAndUrls {
                if range.contains(index) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
}
