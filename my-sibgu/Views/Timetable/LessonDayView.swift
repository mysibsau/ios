//
//  LessonDayView.swift
//  my-sibgu
//
//  Created by art-off on 28.11.2020.
//

import UIKit
import SnapKit

class LessonDayView: UIView {
    
    private let dateTimeService = DateTimeService()
    
    private let dateLabel = UILabel()
    private let dayNameLabel = UILabel()
    private let todayView = UIView()
    private let todayLabel = UILabel()
    private let lessonStackView = UIStackView()
    
    private var dayNumber: Int!
    private var lessonDay: GroupDay?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    convenience init(dayNamber: Int, dayDate: String, day: GroupDay?) {
        self.init()
        self.dayNumber = dayNamber
        self.dayNameLabel.text = dateTimeService.dayOfWeek(number: dayNamber)
        self.dateLabel.text = dayDate
        self.lessonDay = day
        set(day: day)
    }
    
    // MARK: - Methods
    func makeToday() {
        self.addSubview(todayView)
        todayView.translatesAutoresizingMaskIntoConstraints = false
        todayView.leadingAnchor.constraint(equalTo: dayNameLabel.trailingAnchor, constant: 15).isActive = true
        todayView.centerYAnchor.constraint(equalTo: dayNameLabel.centerYAnchor).isActive = true
        todayView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        todayView.backgroundColor = Colors.red
        todayView.layer.cornerRadius = 10
        todayView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 3)

        todayView.addSubview(todayLabel)
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.leadingAnchor.constraint(equalTo: todayView.leadingAnchor, constant: 10).isActive = true
        todayLabel.trailingAnchor.constraint(equalTo: todayView.trailingAnchor, constant: -10).isActive = true
        todayLabel.centerYAnchor.constraint(equalTo: todayView.centerYAnchor).isActive = true

        todayLabel.textColor = .white
        todayLabel.font = UIFont.boldSystemFont(ofSize: 17)
        todayLabel.text = "Сегодня"
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        setupLabels()
        setupStackView()
    }
    
    private func setupLabels() {
        self.addSubview(dayNameLabel)
        dayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dayNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        dayNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        dayNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        dayNameLabel.textColor = Colors.sibsuBlue
        
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: dayNameLabel.centerYAnchor).isActive = true
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        dateLabel.text = "21.01"
    }
    
    private func setupStackView() {
        // настраиваем свойства StackView
        lessonStackView.axis = .vertical
        lessonStackView.distribution = .equalSpacing
        lessonStackView.spacing = 15
        
        self.addSubview(lessonStackView)
        lessonStackView.translatesAutoresizingMaskIntoConstraints = false
        lessonStackView.topAnchor.constraint(equalTo: dayNameLabel.bottomAnchor, constant: 20).isActive = true
        lessonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lessonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        lessonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
    
    private func set(day: GroupDay?) {
        guard let d = day else {
            addWeekday()
            return
        }
        for lesson in d.lessons {
            let lessonView = LessonView(lesson: lesson)
            lessonStackView.addArrangedSubview(lessonView)
            lessonView.widthAnchor.constraint(equalTo: lessonStackView.widthAnchor).isActive = true
        }
    }
    
    private func addWeekday() {
        let weekendView = UIView()
        weekendView.backgroundColor = .systemBackground
        weekendView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 5)
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = Colors.sibsuBlue
        label.text = "Нет пар"
        
        weekendView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: weekendView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: weekendView.centerXAnchor).isActive = true
        
        weekendView.layer.cornerRadius = 15
        weekendView.translatesAutoresizingMaskIntoConstraints = false
        weekendView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        lessonStackView.addArrangedSubview(weekendView)
        weekendView.widthAnchor.constraint(equalTo: lessonStackView.widthAnchor).isActive = true
    }
    
}
