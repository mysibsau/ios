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
    
    private var groups: [Group]?
    private var filtredGroups = [Group]()
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var goToTimetableButton: UIButton!
    
    private let activityIndicator = UIActivityIndicatorView()
    private let helpTableView = UITableView(frame: .zero, style: .plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNabBar()
        
        setupLessonTimetable()
        
        wrapView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 3)
        wrapView.layer.cornerRadius = 10
        
        textField.delegate = self
        
        helpTableView.dataSource = self
        helpTableView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tap)
        
        startAnimating()
        textField.isUserInteractionEnabled = false
        goToTimetableButton.isUserInteractionEnabled = false
        timetableService.getGroups { groups in
            self.textField.isUserInteractionEnabled = true
            self.goToTimetableButton.isUserInteractionEnabled = true
            self.stopAnimating()
            
            guard let g = groups else { return }
            self.groups = g
        }
    }
    
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

        vStackView.addArrangedSubview(header)

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

            hStackView.translatesAutoresizingMaskIntoConstraints = true
            hStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            vStackView.addArrangedSubview(hStackView)
        }
    }
    
    private func _hStackView() -> UIStackView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.backgroundColor = .systemBackground
        hStackView.makeShadow(color: .black, opacity: 0.4, shadowOffser: .zero, radius: 3)
        hStackView.layer.cornerRadius = 10
        
        return hStackView
    }
    
    private func configureNabBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: " Мое расписание")
    }
    
    @objc private func bbb() {
        let vc = TimetableViewController()
        vc.view.backgroundColor = .white
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func startAnimating() {
        if !contentView.subviews.contains(activityIndicator) {
            contentView.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor).isActive = true
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        }
        
        activityIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
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
        let filtred = groups?.filter { $0.name.lowercased().contains(searchText) }.prefix(20)
        self.filtredGroups = Array(filtred!)
        showHelpTable()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showHelpTable()
    }
    
    private func showHelpTable() {
        if !contentView.subviews.contains(helpTableView) {
            contentView.addSubview(helpTableView)
            helpTableView.translatesAutoresizingMaskIntoConstraints = false
            helpTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            helpTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
            helpTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4).isActive = true
            helpTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
            
            helpTableView.layer.cornerRadius = 10
            helpTableView.layer.borderWidth = 0.5
            helpTableView.layer.borderColor = UIColor.gray.cgColor
        }
        helpTableView.isHidden = true
        if !self.filtredGroups.isEmpty {
            helpTableView.isHidden = false
            helpTableView.reloadData()
        }
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
        print("hello")
    }
    
}
