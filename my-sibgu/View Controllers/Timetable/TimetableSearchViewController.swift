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
    private var professors: [Professor]?
    private var places: [Place]?
    private var filtredGroups = [Group]()
    private var filtredProfessors = [Professor]()
    private var filtredPlaces = [Place]()
    private var currType: EntitiesType = .group
    
    // MARK: Outlets
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let wrapView = UIView()
    private let textField = UITextField()
    private let goToTimetableButton = UIButton()
    
    private let favoriteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.Pallete.sibsuBlue
        return label
    }()
    private let favoriteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Private UI
    private let alertView = AlertView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let segmentedControl = UISegmentedControl(items: ["Группа", "Преподаватель", "Кабинет"])
    private let helpTableView = UITableView(frame: .zero, style: .plain)
    
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Pallete.background
        
        setupScrollView()
        setupSegmenterControl()
        setupTextFieldAndButton()
        
        configureNabBar()
        setupFavoriteStackView()
        configurateSearchViews()
        setupHelpTableView()
        addRecognizerToHideKeyboard()
        
        setFavorite(currType)
        setEntriesAndTryShowTimetable()
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    private func setEntriesAndTryShowTimetable() {
        let groupsFromLocal = timetableService.getGroupsFromLocal()
        let professorsFromLocal = timetableService.getProfessorsFromLocal()
        let placesFromLocal = timetableService.getPlacesFromLocal()
        
        if !groupsFromLocal.isEmpty && !professorsFromLocal.isEmpty && !placesFromLocal.isEmpty {
            self.groups = groupsFromLocal
            self.professors = professorsFromLocal
            self.places = placesFromLocal
            tryLoadFromUserDefaults()
        } else {
            startActivityIndicator()
            textField.isUserInteractionEnabled = false
            goToTimetableButton.isUserInteractionEnabled = false
            timetableService.getEntities(ofTypes: [.group, .professor, .place]) { entitiesSet in
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.textField.isUserInteractionEnabled = true
                    self.goToTimetableButton.isUserInteractionEnabled = true
                }
                guard
                    !entitiesSet.groups.isEmpty,
                    !entitiesSet.professors.isEmpty,
                    !entitiesSet.places.isEmpty
                else {
                    DispatchQueue.main.async {
                        self.showNetworkAlert()
                    }
                    return
                }
                
                self.groups = entitiesSet.groups
                self.professors = entitiesSet.professors
                self.places = entitiesSet.places
                
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.textField.isUserInteractionEnabled = true
                    self.goToTimetableButton.isUserInteractionEnabled = true
                    self.tryLoadFromUserDefaults()
                }
            }
        }
    }
    
    private func tryLoadFromUserDefaults() {
        let (type, id) = self.timetableService.getTimetableTypeAndIdFromUserDefaults()
        
        if type != nil, id != nil {
            self.showTimetable(forType: type!, withId: id!, animated: false)
        }
    }
    
    @objc
    private func updateText() {
        let tableName = "Timetable"
        
        self.navigationItem.setBarLeftMainLogoAndLeftTitle(title: "nav.bar.title".localized(using: tableName))
        
        segmentedControl.setTitle("group".localized(using: tableName), forSegmentAt: 0)
        segmentedControl.setTitle("professor".localized(using: tableName), forSegmentAt: 1)
        segmentedControl.setTitle("place".localized(using: tableName), forSegmentAt: 2)
        
        favoriteTitleLabel.text = "favorite".localized(using: tableName)
        
        switch currType {
        case .group: textField.placeholder = "enter.group.name".localized(using: tableName)
        case .professor: textField.placeholder = "enter.professor.name".localized(using: tableName)
        case .place: textField.placeholder = "enter.place.name".localized(using: tableName)
        }
        
        setFavorite(currType)
    }
    
    private func setFavorite(_ type: EntitiesType) {
        favoriteStackView.removeAllArrangedSubviews()
        
        let favorites = timetableService.getFavoritesFromLocal()
        
        if favorites.isEmpty {
            let label = UILabel()
            label.textColor = UIColor.Pallete.gray
            label.text = "favorite.is.empty".localized(using: "Timetable")
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            favoriteStackView.addArrangedSubview(label)
        } else {
            for favorite in favorites {
                switch favorite {
                case .group(let group):
                    let v = FavoriteTimetableElemView(name: group.name, id: group.id, type: .group)
                    v.delegate = self
                    favoriteStackView.addArrangedSubview(v)
                case .professor(let professor):
                    let v = FavoriteTimetableElemView(name: professor.name, id: professor.id, type: .professor)
                    v.delegate = self
                    favoriteStackView.addArrangedSubview(v)
                case .place(let place):
                    let v = FavoriteTimetableElemView(name: place.name, id: place.id, type: .place)
                    v.delegate = self
                    favoriteStackView.addArrangedSubview(v)
                }
            }
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
    
    private func setupFavoriteStackView() {
        contentView.addSubview(favoriteTitleLabel)
        favoriteTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(wrapView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(favoriteStackView)
        favoriteStackView.snp.makeConstraints { make in
            make.top.equalTo(favoriteTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupHelpTableView() {
        helpTableView.register(
            TimetableElemTableViewCell.self,
            forCellReuseIdentifier: TimetableElemTableViewCell.reuseIdentifier
        )
        
        view.addSubview(helpTableView)
        helpTableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(135)
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
        if !self.filtredGroups.isEmpty || !self.filtredProfessors.isEmpty || !self.filtredPlaces.isEmpty {
            helpTableView.isHidden = false
            helpTableView.reloadData()
        }
    }
    
    private func configurateSearchViews() {
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
    
    // MARK: - Activity
    private func addRecognizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        helpTableView.isHidden = true
        view.endEditing(true)
    }

    @objc private func goToTimetableButtonTapped() {
        guard let group = filtredGroups.first else { return }
        
        showTimetable(forType: currType, withId: group.id, animated: true)
    }
    
    private func prepareForGoToTimetable(entityType: EntitiesType, id: Int) {
        filtredGroups = []
        filtredProfessors = []
        filtredPlaces = []
        textField.text = ""
        helpTableView.isHidden = true
        
        timetableService.saveTimetableTypeAndIdToUserDefaults(type: entityType, id: id)
    }
    
    private func showTimetable(forType type: EntitiesType, withId id: Int, animated: Bool) {
        prepareForGoToTimetable(entityType: type, id: id)
        
        switch type {
        case .group:
            guard let group = groups?.filter({ $0.id == id }).first else { return }
            let timetableVC = ContainerTimetableViewController(viewType: .group(group), alertingDelegate: self)
            navigationController?.pushViewController(timetableVC, animated: animated)
        case .professor:
            guard let professor = professors?.filter({ $0.id == id }).first else { return }
            let timetableVC = ContainerTimetableViewController(viewType: .professor(professor), alertingDelegate: self)
            navigationController?.pushViewController(timetableVC, animated: animated)
        case .place:
            guard let place = places?.filter({ $0.id == id }).first else { return }
            let timetableVC = ContainerTimetableViewController(viewType: .place(place), alertingDelegate: self)
            navigationController?.pushViewController(timetableVC, animated: animated)
        }
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
        setFavorite(currType)
        
        textFieldDidChangeSelection(textField)
    }
    
}

extension TimetableSearchViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        segmentedControl.makeBorder()
        
        goToTimetableButton.makeShadow(opacity: 0.2, radius: 2)
        goToTimetableButton.makeBorder()
        
        wrapView.makeShadow()
        wrapView.makeBorder()
        
        
        
        helpTableView.removeFromSuperview()
        setupHelpTableView()
    }
    
}

extension TimetableSearchViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return true }
        if touchView.isDescendant(of: helpTableView) {
            return false
        }
        if touchView.isDescendant(of: segmentedControl) {
            return false
        }
        return true
    }
    
}

extension TimetableSearchViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        filtredGroups = []
        filtredProfessors = []
        filtredPlaces = []
        guard let searchText = textField.text?.lowercased() else {
            showHelpTable()
            return
        }
        guard !searchText.isEmpty else {
            showHelpTable()
            return
        }
        
        switch currType {
        case .group:
            let filtredGr = groups?.filter { $0.name.lowercased().contains(searchText) }
            self.filtredGroups = Array(filtredGr!)
        case .professor:
            let filtredPr = professors?.filter { $0.name.lowercased().contains(searchText) }
            self.filtredProfessors = Array(filtredPr!)
        case .place:
            let filtredPl = places?.filter { $0.name.lowercased().contains(searchText) }
            self.filtredPlaces = Array(filtredPl!)
        }
        showHelpTable()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showHelpTable()
    }
    
}

extension TimetableSearchViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currType {
        case .group: return filtredGroups.count
        case .professor: return filtredProfessors.count
        case .place: return filtredPlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimetableElemTableViewCell.reuseIdentifier, for: indexPath) as! TimetableElemTableViewCell
        
        switch currType {
        case .group:
            cell.textLabel?.text = filtredGroups[indexPath.row].name
        case .professor:
            cell.textLabel?.text = filtredProfessors[indexPath.row].name
        case .place:
            cell.textLabel?.text = filtredPlaces[indexPath.row].name
        }
        
        cell.backgroundColor = UIColor.Pallete.content
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
}

extension TimetableSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id: Int
        switch currType {
        case .group:
            id = filtredGroups[indexPath.row].id
        case .professor:
            id = filtredProfessors[indexPath.row].id
        case .place:
            id = filtredPlaces[indexPath.row].id
        }
        
        showTimetable(forType: currType, withId: id, animated: true)
    }
    
}

extension TimetableSearchViewController: TimetableElemTableViewCellDelegate {
    
    func didTapButton(at indexPath: IndexPath) {
        switch currType {
        case .group:
            let group = filtredGroups[indexPath.row]
            timetableService.addFavorite(entity: SavedEntity(type: currType, id: group.id))
        case .professor:
            let professor = filtredProfessors[indexPath.row]
            timetableService.addFavorite(entity: SavedEntity(type: currType, id: professor.id))
        case .place:
            let place = filtredPlaces[indexPath.row]
            timetableService.addFavorite(entity: SavedEntity(type: currType, id: place.id))
        }
        showAlert(withText: "add.to.favorite".localized(using: "Timetable"))
        helpTableView.isHidden = true
        setFavorite(currType)
    }
    
}

extension TimetableSearchViewController: FavoriteTimetableElemViewDelegate {
    
    func didTapToDeleteFavorite(with id: Int, type: EntitiesType) {
//        switch currType {
//        case .group:
//            timetableService.deleteFavorite(groupId: id)
//        case .professor:
//            timetableService.deleteFavorite(professorId: id)
//        case .place:
//            timetableService.deleteFavorite(placeId: id)
//        }
        timetableService.deleteFavorite(entity: SavedEntity(type: type, id: id))
        setFavorite(currType)
    }
    
    func didTapToFavorite(with id: Int, type: EntitiesType) {
        showTimetable(forType: type, withId: id, animated: true)
    }
    
}


extension TimetableSearchViewController: AnimatingNetworkProtocol {
    
    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicator
    }
    
    func animatingSuperViewForDisplay() -> UIView {
        return view
    }
    
}

extension TimetableSearchViewController: AlertingViewController {
    
    func alertingSuperViewForDisplay() -> UIView {
        return view
    }
    
    func alertingAlertView() -> AlertView {
        return alertView
    }
    
}
