//
//  DateTimeService.swift
//  my-sibgu
//
//  Created by art-off on 29.11.2020.
//

import Foundation

class DateTimeService {
    
    private let calendar = Calendar(identifier: .iso8601)
    
    func dayOfWeek(number: Int) -> String? {
        let tableName = "Timetable"
        
        let daysOfWeek = [
            0: "monday".localized(using: tableName),
            1: "tuesday".localized(using: tableName),
            2: "wednesday".localized(using: tableName),
            3: "thursday".localized(using: tableName),
            4: "friday".localized(using: tableName),
            5: "saturday".localized(using: tableName),
            6: "sunday".localized(using: tableName),
        ]
        
        return daysOfWeek[number]
    }
    
    func currWeekNumber() -> Int {
        let currWeek = calendar.component(.weekOfYear, from: Date.today)
        let firstWeekIsEven = UserDefaultsConfig.firstWeekIsEven
        
        // проверяем, четная ли текущая неделя
        let currWeekIsEven = (currWeek % 2 == 1 && firstWeekIsEven)
                              || (currWeek % 2 == 0 && !firstWeekIsEven)
        
        return currWeekIsEven ? 1 : 0
    }
    
    func currWeekdayNumber() -> Int {
        var currWeekdayNumber = calendar.component(.weekday, from: Date.today) - 1
        
        if currWeekdayNumber < 1 {
            currWeekdayNumber += 7
        }
        
        return 6
        return currWeekdayNumber
    }
    
    // FIXME: Объединить с нижним методом
    func getDatesEvenWeek() -> [(weekday: String, date: String)] {
        let evenWeekMonday: Date
        if currWeekNumber() == 1 {
            /// если четная, то понедельник четной недели - предыдущий
            evenWeekMonday = Date.today.previous(.monday, considerToday: true)
        } else {
            /// если не четная, то понедельник четной недели - следующий
            evenWeekMonday = Date.today.next(.monday)
        }
        
        var weekdaysAndDates = [(String, String)]()
        
        let shortWeekdaysInRussian = Date.shortWeekdaysInRussian
        
        // добавляем все дни недели и даты, соответствующие им
        for (i, weekday) in shortWeekdaysInRussian.enumerated() {
            let date = calendar.date(byAdding: DateComponents(day: i), to: evenWeekMonday)!
            let shortDate = DateFormatter.shortDateFormatter.string(from: date)
            let weekdayAndDate = (weekday, shortDate)
            weekdaysAndDates.append(weekdayAndDate)
        }
        
        return weekdaysAndDates
    }
    
    func getDatesNotEvenWeek() -> [(weekday: String, date: String)] {
        let evenWeekMonday: Date
        if currWeekNumber() == 0 {
            /// если четная, то понедельник четной недели - предыдущий
            evenWeekMonday = Date.today.previous(.monday, considerToday: true)
        } else {
            /// если не четная, то понедельник четной недели - следующий
            evenWeekMonday = Date.today.next(.monday)
        }
        
        var weekdaysAndDates = [(String, String)]()
        
        let shortWeekdaysInRussian = Date.shortWeekdaysInRussian
        
        // добавляем все дни недели и даты, соответствующие им
        for (i, weekday) in shortWeekdaysInRussian.enumerated() {
            let date = calendar.date(byAdding: DateComponents(day: i), to: evenWeekMonday)!
            let shortDate = DateFormatter.shortDateFormatter.string(from: date)
            let weekdayAndDate = (weekday, shortDate)
            weekdaysAndDates.append(weekdayAndDate)
        }
        
        return weekdaysAndDates
    }
    
}
