//
//  DateFormatter+shortDateFormatter.swift
//  my-sibgu
//
//  Created by art-off on 30.11.2020.
//

import Foundation

extension DateFormatter {
    
    static let shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter
    }()
    
}
