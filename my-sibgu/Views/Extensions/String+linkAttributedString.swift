//
//  String+linkAttributedString.swift
//  my-sibgu
//
//  Created by art-off on 07.01.2021.
//

import Foundation
import UIKit

extension String {
    
    func attributedStringWithLinkAndLinkRangesWithUrl() -> (NSMutableAttributedString, [NSRange: URL]) {
        let linkRegex = try! NSRegularExpression(pattern: "https?://(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,4}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)")
        let results = linkRegex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        let ranges = results.map { $0.range }

        let attributedString = NSMutableAttributedString(string: self)
        
        var rangesAndUrls: [NSRange: URL] = [:]
        for range in ranges {
            let stringUrl = String(self[Range(range, in: self)!])
            attributedString.addAttribute(.foregroundColor, value: Colors.sibsuBlue, range: range)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            rangesAndUrls[range] = URL(string: stringUrl)!
        }
        
        return (attributedString, rangesAndUrls)
    }
    
}
