//
//  TimetableSearchViewController.swift
//  my-sibgu
//
//  Created by art-off on 25.11.2020.
//

import UIKit
import SnapKit

private typealias LessonTime = (number: String, time: String, break: String)

class TimetableSearchViewController: UIViewController {
    
    let timetableService = TimetableService()
    
    // MARK: Properties
    private var groups: [Group]?
    private var filtredGroups = [Group]()
    private var currType: EntitiesType = .group
    
    // MARK: Outlets
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let wrapView = UIView()
    private let textField = UITextField()
    private let goToTimetableButton = UIButton()
    
    private let lessonsStackView = UIStackView()
    
    // MARK: Private UI
    private let alertView = AlertView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let segmentedControl = UISegmentedControl(items: ["Группа", "Преподаватель", "Кабинет"])
    private let helpTableView = UITableView(frame: .zero, style: .plain)
    
    
    private let placeholders = [
        "enter.group.name",
        "enter.professor.name",
        "enter.place.name",
    ]
    
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupScrollView()
        setupSegmenterControl()
        setupTextFieldAndButton()
        
        configureNabBar()
        setupLessonTimetable()
        configurateSearchViews()
        setupHelpTableView()
        addRecognizerToHideKeyboard()
        
        // Либо открываем расписание, либо показываем интерфейс для выбора группы / препода
        let groupsFromLocal = timetableService.getGroupsFromLocal()
        
        if !groupsFromLocal.isEmpty {
            self.groups = groupsFromLocal
            tryLoadFromUserDefaults()
        } else {
            // Берем группы (загружаем или нет)
            startActivityIndicator()
            textField.isUserInteractionEnabled = false
            goToTimetableButton.isUserInteractionEnabled = false
            timetableService.getGroups { groups in
                self.textField.isUserInteractionEnabled = true
                self.goToTimetableButton.isUserInteractionEnabled = true
                self.stopActivityIndicator()
                
                guard let g = groups else {
                    DispatchQueue.main.async {
                        self.showNetworkAlert()
                    }
                    return
                }
                self.groups = g
                
                DispatchQueue.main.async {
                    self.tryLoadFromUserDefaults()
                }
            }
        }
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    private func tryLoadFromUserDefaults() {
        let (type, id) = self.timetableService.getTimetableTypeAndIdFromUserDefaults()
        
        if type != nil, id != nil {
            guard let groupForShowing = groups?.first(where: { $0.id == id }) else { return }
            self.showTimetable(forGroup: groupForShowing, animated: false)
        }
    }
    
    @objc
    private func updateText() {
        let tableName = "Timetable"
        
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "nav.bar.title".localized(using: tableName))
        
        switch currType {
        case .group: textField.placeholder = placeholders[0].localized(using: tableName)
        case .professor: textField.placeholder = placeholders[1].localized(using: tableName)
        case .place: textField.placeholder = placeholders[2].localized(using: tableName)
        }
    }
    
    
    // MARK: - Setup Views
    private func setupScrollView() {
        view.addSubview(scrollView)
        // убираем полосы прокрутки
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view)
        }
    }
    
    private func setupSegmenterControl() {
        segmentedControl.selectedSegmentIndex = 0
        
        contentView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControl), for: .valueChanged)
        segmentedControl.backgroundColor = UIColor.Pallete.Special.segmentedControl
        segmentedControl.makeBorder()
    }
    
    private func setupTextFieldAndButton() {
        // add wrapView to contentView
        contentView.addSubview(wrapView)
        wrapView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // configure wrapView
        wrapView.addSubview(goToTimetableButton)
        goToTimetableButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(70)
        }
        
        wrapView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalTo(goToTimetableButton.snp.leading)
        }
        
        wrapView.backgroundColor = UIColor.Pallete.content
        textField.borderStyle = .none
        textField.placeholder = "Введите название группу"
        textField.font = UIFont.systemFont(ofSize: 14)
        goToTimetableButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        goToTimetableButton.addTarget(self, action: #selector(goToTimetableButtonTapped), for: .touchUpInside)
    }
    
    private func setupLessonTimetable() {
//        let vStackView = UIStackView()
        lessonsStackView.axis = .vertical
        lessonsStackView.distribution = .fillEqually
        lessonsStackView.spacing = 8
        
        contentView.addSubview(lessonsStackView)
        lessonsStackView.snp.makeConstraints { make in
            make.top.equalTo(self.wrapView.snp.bottom).offset(50)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }

        let lessonTimes: [LessonTime] = [
            ("1 лента", "08:00 - 09:30", "10 мин."),
            ("2 лента", "09:40 - 11:10", "20 мин."),
            ("3 лента", "11:30 - 13:00", "30 мин."),
            ("4 лента", "13:30 - 15:00", "10 мин."),
            ("5 лента", "15:10 - 16:40", "10 мин."),
            ("6 лента", "16:50 - 18:20", "10 мин."),
            ("7 лента", "18:30 - 20:00", "10 мин."),
            ("8 лента", "20:10 - 21:40", "-"),
        ]

        let header = _hStackView()

        let numberLabel = UILabel()
        numberLabel.text = "#"
        numberLabel.textAlignment = .center
        let timeLabel = UILabel()
        timeLabel.text = "Время"
        timeLabel.textAlignment = .center
        let breakLabel = UILabel()
        breakLabel.text = "Перерыв"
        breakLabel.textAlignment = .center

        header.addArrangedSubview(numberLabel)
        header.addArrangedSubview(timeLabel)
        header.addArrangedSubview(breakLabel)
        
        let wrapView = _wrapView()
        
        wrapView.addSubview(header)
        header.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        lessonsStackView.addArrangedSubview(wrapView)

        for lessonTime in lessonTimes {
            let hStackView = _hStackView()

            let numberLabel = UILabel()
            numberLabel.text = lessonTime.number
            numberLabel.textAlignment = .center
            numberLabel.textColor = UIColor.Pallete.darkBlue
            let timeLabel = UILabel()
            timeLabel.text = lessonTime.time
            timeLabel.textAlignment = .center
            timeLabel.textColor = UIColor.Pallete.darkBlue
            let breakLabel = UILabel()
            breakLabel.text = lessonTime.break
            breakLabel.textAlignment = .center
            breakLabel.textColor = UIColor.Pallete.darkBlue

            hStackView.addArrangedSubview(numberLabel)
            hStackView.addArrangedSubview(timeLabel)
            hStackView.addArrangedSubview(breakLabel)
            
            let wrapView = _wrapView()
            
            wrapView.addSubview(hStackView)
            hStackView.snp.makeConstraints { make in
                make.edges.equalTo(wrapView)
                make.height.equalTo(50)
            }
            
            lessonsStackView.addArrangedSubview(wrapView)
        }
    }
    
    private func setupHelpTableView() {
        contentView.addSubview(helpTableView)
        helpTableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(20)
            make.top.equalTo(textField.snp.bottom).offset(4)
            make.height.equalTo(300)
        }
        
        helpTableView.layer.cornerRadius = 10
        helpTableView.makeBorder(color: .gray, width: 0.5)
        helpTableView.backgroundColor = UIColor.Pallete.content
        
        helpTableView.dataSource = self
        helpTableView.delegate = self
        
        helpTableView.isHidden = true
    }
    
    private func showHelpTable() {
        helpTableView.isHidden = true
        if !self.filtredGroups.isEmpty {
            helpTableView.isHidden = false
            helpTableView.reloadData()
        }
    }
    
    private func configurateSearchViews() {
//        wrapView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 3)
        wrapView.makeShadow()
        wrapView.makeBorder()
        wrapView.layer.cornerRadius = 10
        
        goToTimetableButton.makeShadow(opacity: 0.2, radius: 2)
        goToTimetableButton.makeBorder()
        goToTimetableButton.backgroundColor = UIColor.Pallete.content
        goToTimetableButton.layer.cornerRadius = 10
        
        textField.delegate = self
    }
    
    private func configureNabBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
    }
    
    // MARK: - Helper UI
    private func _hStackView() -> UIStackView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        
        return hStackView
    }
    
    private func _wrapView() -> UIView {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.makeShadow()
        v.makeBorder()
        v.backgroundColor = UIColor.Pallete.content
        v.layer.cornerRadius = 10
        
        return v
    }
    
    // MARK: - Activity
    private func addRecognizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func goToTimetableButtonTapped() {
        guard let group = filtredGroups.first else { return }
        
        showTimetable(forGroup: group, animated: true)
    }
    
    private func prepareForGoToTimetable(entityType: EntitiesType, id: Int) {
        filtredGroups = []
        textField.text = ""
        helpTableView.isHidden = true
        
        timetableService.saveTimetableTypeAndIdToUserDefaults(type: entityType, id: id)
    }
    
    private func showTimetable(forGroup group: Group, animated: Bool) {
        prepareForGoToTimetable(entityType: .group, id: group.id)
        
        let timetableVC = ContainerTimetableViewController(group: group, alertingDelegate: self) //TimetableViewController(group: group, alertingDelegate: self)
        navigationController?.pushViewController(timetableVC, animated: animated)
    }
    
    @objc
    private func didChangeSegmentedControl() {
        let index = segmentedControl.selectedSegmentIndex
        switch index {
        case 0:
            currType = .group
        case 1:
            currType = .professor
        case 2:
            currType = .place
        default:
            break
        }
        updateText()
    }
    
}

extension TimetableSearchViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        segmentedControl.makeBorder()
        
        goToTimetableButton.makeShadow(opacity: 0.2, radius: 2)
        goToTimetableButton.makeBorder()
        
        wrapView.makeShadow()
        wrapView.makeBorder()
        
        lessonsStackView.removeAllArrangedSubviews()
        setupLessonTimetable()
        
        helpTableView.removeFromSuperview()
        setupHelpTableView()
    }
    
}

extension TimetableSearchViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased() else {
            filtredGroups = []
            showHelpTable()
            return
        }
        guard !searchText.isEmpty else {
            filtredGroups = []
            showHelpTable()
            return
        }
        let filtred = groups?.filter { $0.name.lowercased().contains(searchText) }//.prefix(20)
        self.filtredGroups = Array(filtred!)
        showHelpTable()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showHelpTable()
    }
    
}

extension TimetableSearchViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = filtredGroups[indexPath.row].name
        cell.backgroundColor = UIColor.Pallete.content
        return cell
    }
    
}

extension TimetableSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = filtredGroups[indexPath.row]
        
        showTimetable(forGroup: group, animated: true)
    }
    
}



extension TimetableSearchViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicator
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return contentView
    }
    
}

extension TimetableSearchViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        return contentView
    }
    
    func alertingAlertView() -> AlertView {
        return alertView
    }
    
}
