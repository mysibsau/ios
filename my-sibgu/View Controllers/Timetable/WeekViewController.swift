//
//  WeekViewController.swift
//  my-sibgu
//
//  Created by art-off on 29.11.2020.
//

import UIKit

class WeekViewController: UIViewController {
    
    private let timetableSercive = TimetableService()
    private let dateTimeService = DateTimeService()
    
    
    private var week: GroupWeek!
    var weekNumber: Int!
    var todayNumber: Int?
    
    
    private var lessonDayViews = [LessonDayView]()
    
    // MARK: - Private UI
    private let scrollView = UIScrollView()
    private let dayStackView = UIStackView()
    
    
    // MARK: - Initialization
    convenience init(week: GroupWeek, weekNumber: Int, todayNumber: Int?) {
        self.init()
        self.week = week
        self.weekNumber = weekNumber
        self.todayNumber = todayNumber
        self.set(lessonWeek: week)
    }
    
    // MARK: - Ovverides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupStackView()
        
        view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText() {
//        let tableName = "Timetable"
        
        lessonDayViews.removeAll()
        dayStackView.removeAllArrangedSubviews()
        set(lessonWeek: week)
    }
    
    
    // MARK: - Setup Views
    private func setupScrollView() {
        view.addSubview(scrollView)
        // убираем полосы прокрутки
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        // настраиваем свойства StackView
        dayStackView.axis = .vertical
        dayStackView.distribution = .equalSpacing
        dayStackView.spacing = 5
        
        scrollView.addSubview(dayStackView)
        dayStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(scrollView)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView)
        }
    }
    
    // MARK: - Set Lesson Days
    private func set(lessonWeek: GroupWeek) {
        let weekdaysAndDates: [(weekday: String, date: String)]
        if weekNumber == 0 {
            weekdaysAndDates = dateTimeService.getDatesNotEvenWeek()
        } else {
            weekdaysAndDates = dateTimeService.getDatesEvenWeek()
        }
        
        for (i, day) in lessonWeek.days.enumerated() {
            let lessonDayView = LessonDayView(dayNamber: i, dayDate: weekdaysAndDates[i].date, day: day)
            lessonDayViews.append(lessonDayView)
            dayStackView.addArrangedSubview(lessonDayView)
        }
        
        // Если сегодняшний день на этой недели
        if let todayNumber = todayNumber {
            view.layoutIfNeeded()
            guard todayNumber >= 0 && todayNumber <= 5 else { return }
            let todayView = lessonDayViews[todayNumber]
            todayView.makeToday()
            scrollView.setContentOffset(todayView.frame.origin, animated: true)
        }
    }
    
}
