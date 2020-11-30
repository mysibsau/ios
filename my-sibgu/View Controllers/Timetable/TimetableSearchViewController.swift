//
//  TimetableSearchViewController.swift
//  my-sibgu
//
//  Created by art-off on 25.11.2020.
//

import UIKit

private typealias LessonTime = (number: String, time: String, break: String)

class TimetableSearchViewController: UIViewController {
    
    let timetableService = TimetableService()
    
    // MARK: Properties
    private var groups: [Group]?
    private var filtredGroups = [Group]()
    
    // MARK: Outlets
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var goToTimetableButton: UIButton!
    
    // MARK: Private UI
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let helpTableView = UITableView(frame: .zero, style: .plain)
    
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNabBar()
        setupLessonTimetable()
        configurateSearchViews()
        setupHelpTableView()
        addRecognizerToHideKeyboard()
        
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
                
                guard let g = groups else { return }
                self.groups = g
                
                DispatchQueue.main.async {
                    self.tryLoadFromUserDefaults()
                }
            }
        }
    }
    
    private func tryLoadFromUserDefaults() {
        let (type, id) = self.timetableService.getTimetableTypeAndIdFromUserDefaults()
        
        if type != nil, id != nil {
            guard let groupForShowing = groups?.first(where: { $0.id == id }) else { return }
            self.showTimetable(forGroup: groupForShowing, animated: false)
        }
    }
    
    
    // MARK: - Setup Views
    private func setupLessonTimetable() {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 8

        contentView.addSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        vStackView.topAnchor.constraint(equalTo: wrapView.bottomAnchor, constant: 50).isActive = true
        vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true

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
        wrapView.translatesAutoresizingMaskIntoConstraints = false
        
        wrapView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.addConstraintsOnAllSides(to: wrapView, withConstant: 0)

        vStackView.addArrangedSubview(wrapView)

        for lessonTime in lessonTimes {
            let hStackView = _hStackView()

            let numberLabel = UILabel()
            numberLabel.text = lessonTime.number
            numberLabel.textAlignment = .center
            numberLabel.textColor = Colors.myBlue
            let timeLabel = UILabel()
            timeLabel.text = lessonTime.time
            timeLabel.textAlignment = .center
            timeLabel.textColor = Colors.myBlue
            let breakLabel = UILabel()
            breakLabel.text = lessonTime.break
            breakLabel.textAlignment = .center
            breakLabel.textColor = Colors.myBlue

            hStackView.addArrangedSubview(numberLabel)
            hStackView.addArrangedSubview(timeLabel)
            hStackView.addArrangedSubview(breakLabel)
            
            let wrapView = _wrapView()
            wrapView.translatesAutoresizingMaskIntoConstraints = false
            
            wrapView.addSubview(hStackView)
            hStackView.translatesAutoresizingMaskIntoConstraints = false
            hStackView.addConstraintsOnAllSides(to: wrapView, withConstant: 0)
            hStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            vStackView.addArrangedSubview(wrapView)
        }
    }
    
    private func setupHelpTableView() {
        contentView.addSubview(helpTableView)
        helpTableView.translatesAutoresizingMaskIntoConstraints = false
        helpTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        helpTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        helpTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4).isActive = true
        helpTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        helpTableView.layer.cornerRadius = 10
        helpTableView.layer.borderWidth = 0.5
        helpTableView.layer.borderColor = UIColor.gray.cgColor
        
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
        wrapView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 3)
        wrapView.layer.cornerRadius = 10
        
        goToTimetableButton.makeShadow(color: .black, opacity: 0.2, shadowOffser: .zero, radius: 2)
        goToTimetableButton.backgroundColor = .systemBackground
        goToTimetableButton.layer.cornerRadius = 10
        
        textField.delegate = self
    }
    
    private func configureNabBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "Мое расписание")
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
        v.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 3)
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

    @IBAction func goToTimetableButtonTapped(_ sender: UIButton) {
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
        
        let timetableVC = TimetableViewController(group: group)
        navigationController?.pushViewController(timetableVC, animated: animated)
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
