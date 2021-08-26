//
//  String+linkAttributedString.swift
//  my-sibgu
//
//  Created by art-off on 07.01.2021.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    func addAttributesWithPhoneNumbers() -> [NSRange: URL] {
        let phoneNumberRegex = #"(\+7|8) ?[\( -]?\d{3}[\) -]? ?\d{3}[ -]?\d{2}[ -]?\d{2}"#
        return addAttributesAndGetParsePhoneNumber(stringRegex: phoneNumberRegex, attrString: self)
    }

    func addAttributesWithLinkAndLinkRangesWithUrl() -> [NSRange: URL] {
        let stringLinkRegex = "https?://(www\\.)?[-a-zA-ZА-Яа-я0-9@:%._\\+~#=]{2,256}\\.[А-Яа-яa-z]{2,4}\\b([-a-zA-ZА-Яа-я0-9@:%_\\+.~#?&//=]*)"
        
        // Нельзя менять местами, потому что первый заменяет все шаблоны [текст](ссылка)
        // если выполнить сначала второй - то 2 раза добавить ссылку в словарь
        let rangesAndUrlByNamedLink = addAttributesAndGetParseNamedLink(stringLinkRegex: stringLinkRegex, attrString: self)
        var rangesAndUrlByLink = addAttributesAndGetParseLink(stringLinkRegex: stringLinkRegex, attrString: self)
        
        rangesAndUrlByLink.merge(dict: rangesAndUrlByNamedLink)
        return rangesAndUrlByLink
    }
    
    func addAttributesWithEmailAndEmailRangesWithUrl() -> [NSRange: URL] {
        let stringEmailRegex = "[А-Яа-яA-Z0-9a-z._%+-]+@[А-Яа-яA-Za-z0-9.-]+\\.[А-Яа-яA-Za-z]{2,64}"
        
        var rangesAndUrlByLink = addAttributesAndGetParseEmail(stringEmailRegex: stringEmailRegex, attrString: self)
        
        return rangesAndUrlByLink
    }
    
    private func addAttributesAndGetParsePhoneNumber(stringRegex: String,
                                                     attrString: NSMutableAttributedString) -> [NSRange: URL] {
        let phoneRegex = try! NSRegularExpression(pattern: stringRegex)
        
        let ranges = phoneRegex
            .matches(in: attrString.string,
                     range: NSRange(attrString.string.startIndex..., in: attrString.string))
            .map(\.range)
        
        var rangesAndUrls: [NSRange: URL] = [:]
        for range in ranges {
            if let url = String(attrString.string[Range(range, in: attrString.string)!]).phoneUrl {
                attrString.addAttribute(.foregroundColor, value: UIColor.Pallete.sibsuBlue, range: range)
                attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                rangesAndUrls[range] = url
            }
        }
        return rangesAndUrls
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
            var stringUrl = String(attrString.string[Range(range, in: attrString.string)!])
            while [".", ",", ":"].contains(stringUrl.last) {
                stringUrl.removeLast()
            }
            attrString.addAttribute(.foregroundColor, value: UIColor.Pallete.sibsuBlue, range: range)
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
            var stringUrl = String(nameAndLink[Range(linkRangeWitoutFirstAndLast, in: nameAndLink)!])
            while [".", ",", ":"].contains(stringUrl.last) {
                stringUrl.removeLast()
            }
            let url = URL(string: stringUrl.encodeUrl) ?? URL(string: "https://www.google.com/?client=safari")!
            
            attrString.replaceCharacters(in: nameAndLinkRange!, with: name)
            let newRange = NSRange(location: nameAndLinkRange!.location, length: name.count)
            
            attrString.addAttribute(.foregroundColor, value: UIColor.Pallete.sibsuBlue, range: newRange)
            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: newRange)
            rangesAndUrls[newRange] = url
            
            nameAndLinkRange = namedLinkRegex.firstMatch(in: attrString.string, range: NSRange(attrString.string.startIndex..., in: attrString.string))?.range
        }
        
        return rangesAndUrls
    }
    
    private func addAttributesAndGetParseEmail(stringEmailRegex: String, attrString: NSMutableAttributedString) -> [NSRange: URL] {
        let emailRegex = try! NSRegularExpression(pattern: stringEmailRegex)

        let results = emailRegex.matches(
            in: attrString.string,
            range: NSRange(attrString.string.startIndex..., in: attrString.string)
        )
        let ranges = results.map { $0.range }
        
        var rangesAndUrls: [NSRange: URL] = [:]
        for range in ranges {
            let stringUrl = String(attrString.string[Range(range, in: attrString.string)!])
            attrString.addAttribute(.foregroundColor, value: UIColor.Pallete.sibsuBlue, range: range)
            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            rangesAndUrls[range] = URL(string: "mailto:\(stringUrl)")!
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

extension String{
    
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var decodeUrl : String {
        return self.removingPercentEncoding!
    }
}

extension String {

    var phoneUrl: URL? {
        let digitFiltered = self.filter {
            ([0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map(String.init) + ["+"])
                .contains(String($0))
        }
        return URL(string: "tel://\(digitFiltered)")
    }
}
