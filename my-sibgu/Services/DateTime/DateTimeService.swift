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
        
        return currWeekIsEven ? 1 : 0
    }
    
    func currWeekdayNumber() -> Int {
        var currWeekdayNumber = Calendar.current.component(.weekday, from: Date.today) - 1
        
        if currWeekdayNumber < 1 {
            currWeekdayNumber += 7
        }
        
        return currWeekdayNumber
    }
    
}
