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
        let stringLinkRegex = "https?://(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,4}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)"
        
        let attrString = NSMutableAttributedString(string: self)
        
        // Нельзя менять местами, потому что первый заменяет все шаблоны [текст](ссылка)
        // если выполнить сначала второй - то 2 раза добавить ссылку в словарь
        let rangesAndUrlByNamedLink = addAttributesAndGetParseNamedLink(stringLinkRegex: stringLinkRegex, attrString: attrString)
        var rangesAndUrlByLink = addAttributesAndGetParseLink(stringLinkRegex: stringLinkRegex, attrString: attrString)
        
        rangesAndUrlByLink.merge(dict: rangesAndUrlByNamedLink)
        return (attrString, rangesAndUrlByLink)
    }

    private func addAttributesAndGetParseLink(stringLinkRegex: String, attrString: NSMutableAttributedString) -> [NSRange: URL] {
        let linkRegex = try! NSRegularExpression(pattern: stringLinkRegex)

        let results = linkRegex.matches(
            in: attrString.string,
            range: NSRange(attrString.string.startIndex..., in: attrString.string)
        )
        let ranges = results.map { $0.range }
        
        var rangesAndUrls: [NSRange: URL] = [:]
        for range in ranges {
            let stringUrl = String(attrString.string[Range(range, in: attrString.string)!])
            attrString.addAttribute(.foregroundColor, value: Colors.sibsuBlue, range: range)
            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            rangesAndUrls[range] = URL(string: stringUrl)!
        }
        
        return rangesAndUrls
    }
    
    private func addAttributesAndGetParseNamedLink(stringLinkRegex: String, attrString: NSMutableAttributedString) -> [NSRange: URL] {
        let namedLinkRegex = try! NSRegularExpression(pattern: "\\[(.*?)\\]\\(\(stringLinkRegex)\\)")

        let nameRegex = try! NSRegularExpression(pattern: "\\[(.*?)\\]")
        let linkRegex = try! NSRegularExpression(pattern: "\\((.*?)\\)")
        
        var rangesAndUrls: [NSRange: URL] = [:]
        
        var nameAndLinkRange: NSRange? = namedLinkRegex.firstMatch(in: attrString.string, range: NSRange(attrString.string.startIndex..., in: attrString.string))?.range
        
        while nameAndLinkRange != nil {
            let nameAndLink = String(attrString.string[Range(nameAndLinkRange!, in: attrString.string)!])
            let nameRange = nameRegex.firstMatch(in: nameAndLink, range: NSRange(nameAndLink.startIndex..., in: nameAndLink))!.range
            let linkRange = linkRegex.firstMatch(in: nameAndLink, range: NSRange(nameAndLink.startIndex..., in: nameAndLink))!.range
            
            let nameRangeWitoutFirstAndLast = NSRange(location: nameRange.location + 1, length: nameRange.length - 2)
            let linkRangeWitoutFirstAndLast = NSRange(location: linkRange.location + 1, length: linkRange.length - 2)
            
            let name = String(nameAndLink[Range(nameRangeWitoutFirstAndLast, in: nameAndLink)!])
            let stringUrl = String(nameAndLink[Range(linkRangeWitoutFirstAndLast, in: nameAndLink)!])
            let url = URL(string: stringUrl)!
            
            attrString.replaceCharacters(in: nameAndLinkRange!, with: name)
            let newRange = NSRange(location: nameAndLinkRange!.location, length: name.count)
            
            attrString.addAttribute(.foregroundColor, value: Colors.sibsuBlue, range: newRange)
            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: newRange)
            rangesAndUrls[newRange] = url
            
            nameAndLinkRange = namedLinkRegex.firstMatch(in: attrString.string, range: NSRange(attrString.string.startIndex..., in: attrString.string))?.range
        }
        
        return rangesAndUrls
    }

}

extension Dictionary {
    
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
    
}
