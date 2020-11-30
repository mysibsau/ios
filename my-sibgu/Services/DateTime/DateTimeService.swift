//
//  DateTimeService.swift
//  my-sibgu
//
//  Created by art-off on 29.11.2020.
//

import Foundation

class DateTimeService {
    
    private let daysOfWeek = [
        0: "Понедельник",
        1: "Вторник",
        2: "Среда",
        3: "Четверг",
        4: "Пятница",
        5: "Суббота",
        6: "Воскресенье",
    ]
    
    func dayOfWeek(number: Int) -> String? {
        return daysOfWeek[number]
    }
    
    func currWeekNumber() -> Int {
        let currWeek = Calendar.current.component(.weekday, from: Date.today)
        let firstWeekIsEven = UserDefaultsConfig.firstWeekIsEven
        
        // проверяем, четная ли текущая неделя
        let currWeekIsEven = (currWeek % 2 == 1 && firstWeekIsEven)
                              || (currWeek % 2 == 0 && !firstWeekIsEven)
        
        return currWeekIsEven ? 0 : 1
    }
    
    func currWeekdayNumber() -> Int {
        var currWeekdayNumber = Calendar.current.component(.weekday, from: Date.today) - 1
        
        if currWeekdayNumber < 1 {
            currWeekdayNumber += 7
        }
        
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
        
        let calendar = Calendar.current
        
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
        
        let calendar = Calendar.current
        
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
