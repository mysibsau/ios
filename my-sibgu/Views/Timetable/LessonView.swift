//
//  LessonView.swift
//  my-sibgu
//
//  Created by art-off on 25.11.2020.
//

import UIKit

class LessonView: UIView {
    
    private let contentView = UIView()
    private let wrapperView = UIView()
    private let subgroupStackView = UIStackView()
    
    var spacing: CGFloat = 2 {
        didSet { subgroupStackView.spacing = self.spacing }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupStackView()
        
        contentView.backgroundColor = UIColor.Pallete.content
        contentView.makeShadow()
        contentView.makeBorder()
        contentView.layer.cornerRadius = 15
    }
    
    private func setupStackView() {
        // настраиваем свойства StackView
        subgroupStackView.axis = .vertical
        subgroupStackView.distribution = .equalSpacing
        subgroupStackView.spacing = spacing // было 2
        
        contentView.addSubview(wrapperView)
        wrapperView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(4)
            make.leading.trailing.equalTo(contentView).inset(8)
        }
        
        wrapperView.addSubview(subgroupStackView)
        subgroupStackView.snp.makeConstraints { make in
            make.edges.equalTo(wrapperView).inset(8)
        }
    }
}


// MARK: - Все для установки нового занятия на это вью (пока только для групп)
extension LessonView {
    
    convenience init(lesson: LessonViewModel) {
        self.init()
        self.set(lesson: lesson)
    }
    
    // MARK: Установка нового занятия для группы
    private func set(lesson: LessonViewModel) {
        // если тут уже было занятие, то удаляем его
        subgroupStackView.removeAllArrangedSubviews()
        
        addTime(time: lesson.time)
        
        var numberSubgroup = 1
        for subgroup in lesson.subgroups {
            addSeparatorLine()
            // добавляем номер подргуппы, если это необходимо
            if subgroup.number != 0 {
                addNumberSubgroup(with: subgroup.number)
            }
            
            // перечисляем всех преподавателей через ;\n
            //let professors = subgroup.professors.reduce("", { $0 + ($0 != "" ? ";\n": "") + $1 })
            addSubgroup(subject: subgroup.subject, type: subgroup.type, proffesor: subgroup.addInfo1, place: subgroup.addInfo2)
            
//            // добавляем разделительную если это необходимо
//            if lesson.subgroups.count > 1 && lesson.subgroups.count != numberSubgroup {
//                addSeparatorLine()
//            }
            numberSubgroup += 1
        }
    }
    
//    // MARK: Установка нового занятия для проподавателей
//    private func set(lesson: ProfessorLesson) {
//        // если тут уже было занятие, то удаляем его
//        subgroupStackView.removeAllArrangedSubviews()
//
//        addTime(time: lesson.time)
//
//        var numberSubgroup = 1
//        for subgroup in lesson.subgroups {
//            // добавляем номер подргуппы, если это необходимо
//            if subgroup.number != 0 {
//                addNumberSubgroup(with: subgroup.number)
//            }
//
//            // перечисляем все группы через ;\n
//            let professors = subgroup.groups.reduce("", { $0 + ($0 != "" ? ";\n": "") + $1 })
//            addSubgroup(subject: subgroup.subject, type: subgroup.type, proffesor: professors, place: subgroup.place)
//
//            // добавляем разделительную если это необходимо
//            if lesson.subgroups.count > 1 && lesson.subgroups.count != numberSubgroup {
//                addSeparatorLine()
//            }
//            numberSubgroup += 1
//        }
//    }
//
//    // MARK: Установка нового занятия для кабинетов
//    private func set(lesson: PlaceLesson) {
//        // если тут уже было занятие, то удаляем его
//        subgroupStackView.removeAllArrangedSubviews()
//
//        addTime(time: lesson.time)
//
//        var numberSubgroup = 1
//        for subgroup in lesson.subgroups {
//            // добавляем номер подргуппы, если это необходимо
//            if subgroup.number != 0 {
//                addNumberSubgroup(with: subgroup.number)
//            }
//
//            // перечисляем все группы через ;\n
//            let professors = subgroup.groups.reduce("", { $0 + ($0 != "" ? ";\n": "") + $1 })
//            // перечисляем все группы через ;\n
//            let groups = subgroup.groups.reduce("", { $0 + ($0 != "" ? ";\n": "") + $1 })
//            addSubgroup(subject: subgroup.subject, type: subgroup.type, professors: professors, groups: groups)
//
//            // добавляем разделительную если это необходимо
//            if lesson.subgroups.count > 1 && lesson.subgroups.count != numberSubgroup {
//                addSeparatorLine()
//            }
//            numberSubgroup += 1
//        }
//    }
    
    // MARK: Добавление времени к занятию
    private func addTime(time: String) {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 19)
        timeLabel.text = time
        timeLabel.textAlignment = .center
        
        subgroupStackView.addArrangedSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.width.equalTo(subgroupStackView)
        }
    }
    
    // MARK: Добавление номера группы (для подргупп)
    private func addNumberSubgroup(with number: Int) {
        let numberSubgroundLabel = UILabel()
        numberSubgroundLabel.font = UIFont.systemFont(ofSize: 10)
        numberSubgroundLabel.textColor = UIColor.Pallete.gray
        numberSubgroundLabel.text = "[\(number) подгруппа]"
        numberSubgroundLabel.textAlignment = .left
        
        subgroupStackView.addArrangedSubview(numberSubgroundLabel)
        numberSubgroundLabel.snp.makeConstraints { make in
            make.width.equalTo(subgroupStackView)
        }
    }
    
    // MARK: Добавлени разделительной линии (для подгрупп)
    func addSeparatorLine() {
        // добавление дополнительного отступа перед линией
        let spaceBeforeLine = UIView()
        spaceBeforeLine.backgroundColor = .clear
        
        subgroupStackView.addArrangedSubview(spaceBeforeLine)
        spaceBeforeLine.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(subgroupStackView)
        }
        
        // добавление разделительной черты
        let separator = UIView()
        let line = UIView()
        separator.backgroundColor = .clear
        line.backgroundColor = UIColor.Pallete.gray

        separator.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.bottom.equalTo(separator)
            make.width.equalTo(separator).multipliedBy(0.8)
            make.centerX.equalTo(separator)
        }

        subgroupStackView.addArrangedSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(subgroupStackView)
        }
        
        // добавление дополнительного отступа после лини
        let spaceAfterLine = UIView()
        spaceAfterLine.backgroundColor = .clear
        
        subgroupStackView.addArrangedSubview(spaceAfterLine)
        spaceAfterLine.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo(subgroupStackView)
        }
    }
    
    // MARK: Добавление подргуппы (испльзутеся и тогда, когда подргуппа одна) (для ГРУПП)
    private func addSubgroup(subject: String, type: SubgroupType, proffesor: String, place: String) {
        let subgroupView = GroupSubgroupView()
        subgroupView.subject.text = subject
        subgroupView.type.text = type.localized
        if type == .lecrute {
            subgroupView.type.textColor = UIColor.Pallete.orange
        } else if type == .practice {
            subgroupView.type.textColor = UIColor.Pallete.green
        } else if type == .laboratoryWork {
            subgroupView.type.textColor = UIColor.Pallete.purple
        } else {
            subgroupView.type.textColor = UIColor.Pallete.gray
        }
        subgroupView.professor.text = proffesor
        subgroupView.place.text = place
        
        subgroupStackView.addArrangedSubview(subgroupView)
        // возможно эта строчка и не нужна
        //subgroupView.widthAnchor.constraint(equalTo: subgroupStackView.widthAnchor).isActive = true
    }
    
//    // MARK: Добавление подргуппы (для ПРЕПОДАВАТЕЛЕЙ)
//    private func addSubgroup(subject: String, type: String, groups: String, place: String) {
//        let subgroupView = ProfessorSubgroupView()
//        subgroupView.subject.text = subject
//        subgroupView.type.text = type
//        subgroupView.group.text = groups
//        subgroupView.place.text = place
//
//        subgroupStackView.addArrangedSubview(subgroupView)
//        // возможно эта строчка и не нужна
//        //subgroupView.widthAnchor.constraint(equalTo: subgroupStackView.widthAnchor).isActive = true
//    }
//
//    // MARK: Добавление одргуппы (для КАБИНЕТОВ)
//    private func addSubgroup(subject: String, type: String, professors: String, groups: String) {
//        let subgroupView = PlaceSubgroupView()
//        subgroupView.subject.text = subject
//        subgroupView.type.text = type
//        subgroupView.professor.text = professors
//        subgroupView.group.text = groups
//
//        subgroupStackView.addArrangedSubview(subgroupView)
//        // возможно эта строчка и не нужна
//        //subgroupView.widthAnchor.constraint(equalTo: subgroupStackView.widthAnchor).isActive = true
//    }
    
}

extension LessonView {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        contentView.makeShadow()
        contentView.makeBorder()
    }
    
}
