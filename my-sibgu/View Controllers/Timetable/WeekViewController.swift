//
//  WeekViewController.swift
//  my-sibgu
//
//  Created by art-off on 29.11.2020.
//

import UIKit

class WeekViewController: UIViewController {
    
    private let timetableSercive = TimetableService()
    
    
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
    }
    
    
    // MARK: - Setup Views
    private func setupScrollView() {
        view.addSubview(scrollView)
        // убираем полосы прокрутки
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraintsOnAllSides(to: view.safeAreaLayoutGuide, withConstant: 0)
    }
    
    private func setupStackView() {
        // настраиваем свойства StackView
        dayStackView.axis = .vertical
        dayStackView.distribution = .equalSpacing
        dayStackView.spacing = 5
        
        scrollView.addSubview(dayStackView)
        dayStackView.translatesAutoresizingMaskIntoConstraints = false
        dayStackView.addConstraintsOnAllSides(to: scrollView, withConstantForTop: 0, leadint: 0, trailing: 0, bottom: -8)
        dayStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    // MARK: - Set Lesson Days
    private func set(lessonWeek: GroupWeek) {
        for (i, day) in lessonWeek.days.enumerated() {
            let lessonDayView = LessonDayView(number: i, day: day)
            lessonDayViews.append(lessonDayView)
            dayStackView.addArrangedSubview(lessonDayView)
        }
        
        // Если сегодняшний день на этой недели
        if let todayNumber = todayNumber {
            view.layoutIfNeeded()
            guard todayNumber > 0 && todayNumber < 5 else { return }
            let todayView = lessonDayViews[todayNumber]
            todayView.makeToday()
            scrollView.setContentOffset(todayView.frame.origin, animated: true)
        }
    }
    
}
