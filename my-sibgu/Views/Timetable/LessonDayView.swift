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
        todayView.snp.makeConstraints { make in
            make.leading.equalTo(dayNameLabel.snp.trailing).offset(15)
            make.centerY.equalTo(dayNameLabel)
            make.height.equalTo(30)
        }

        todayView.backgroundColor = UIColor.Pallete.lightRed
        todayView.layer.cornerRadius = 10
        todayView.makeShadow(color: UIColor.Pallete.shadow, opacity: 0.4, shadowOffser: .zero, radius: 3)

        todayView.addSubview(todayLabel)
        todayLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(todayView).inset(10)
            make.centerY.equalTo(todayView)
        }
        
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
        dayNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(30)
        }
        
        dayNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        dayNameLabel.textColor = UIColor.Pallete.sibsuBlue
        
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-30)
            make.centerY.equalTo(dayNameLabel)
        }
        
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = UIColor.Pallete.gray
        dateLabel.text = "21.01"
    }
    
    private func setupStackView() {
        // настраиваем свойства StackView
        lessonStackView.axis = .vertical
        lessonStackView.distribution = .equalSpacing
        lessonStackView.spacing = 15
        
        self.addSubview(lessonStackView)
        lessonStackView.snp.makeConstraints { make in
            make.top.equalTo(dayNameLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(self).inset(20)
        }
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
        weekendView.layer.cornerRadius = 15
        weekendView.makeShadow(color: UIColor.Pallete.shadow, opacity: 0.4, shadowOffser: .zero, radius: 5)
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.Pallete.sibsuBlue
        label.text = "Нет пар"
        
        weekendView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(weekendView)
        }

        lessonStackView.addArrangedSubview(weekendView)
        weekendView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(lessonStackView)
        }
    }
    
}
