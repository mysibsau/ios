//
//  ContainerTimetableViewController.swift
//  my-sibgu
//
//  Created by art-off on 02.12.2020.
//

import UIKit
import SnapKit

class ContainerTimetableViewController: UIViewController {
    
    private let timetableService = TimetableService()
    
    var group: Group?
    
    var alertingViewController: AlertingViewController?
    private var showingTimetableViewController: ShowingTimetableViewController!
    
    private let containerView = UIView()
    private let rightBarButton = UIButton()
    
    
    convenience init(group: Group, alertingDelegate: AlertingViewController) {
        self.init()
        self.group = group
        self.alertingViewController = alertingDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let timetableViewController = TimetableViewController(group: group!, controlDelegate: self, alertingDelegate: alertingViewController!)
        self.addChild(timetableViewController)
        
        containerView.addSubview(timetableViewController.view)
        
        timetableViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        timetableViewController.didMove(toParent: self)
        
        showingTimetableViewController = timetableViewController
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText() {
        let tableName = "Timetable"
        
        guard let number = rightBarButton.titleLabel?.text?.first else { return }
        rightBarButton.setTitle("\(number) \("week".localized(using: tableName))", for: .normal)
    }
    
    private func setupNavBar() {
        self.navigationController?.configurateNavigationBar()
        self.navigationItem.configurate()
        self.navigationItem.setLeftExitButtonAndLeftTitle(title: group!.name, vc: self)
        
        setupRightBarButton()
    }
    
    private func setupRightBarButton() {
        rightBarButton.setTitle("1 неделя", for: .normal)
        rightBarButton.setTitleColor(.gray, for: .normal)
        rightBarButton.addTarget(self, action: #selector(scrollToOthreWeek), for: .touchUpInside)
        
        let viewRightBarButton = UIView()
        viewRightBarButton.addSubview(rightBarButton)
        viewRightBarButton.makeShadow(color: UIColor.Pallete.shadow, opacity: 0.3, shadowOffser: .zero, radius: 2.5)
        viewRightBarButton.layer.cornerRadius = 15
        
        rightBarButton.snp.makeConstraints { make in
            make.center.equalTo(viewRightBarButton.snp.center)
        }
        
        viewRightBarButton.backgroundColor = UIColor.Pallete.background
        viewRightBarButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewRightBarButton)
    }
    
    @objc private func scrollToOthreWeek() {
        showingTimetableViewController.scrollToOtherWeek()
    }

}

extension ContainerTimetableViewController: PopableViewController {

    func popViewController() {
        timetableService.saveTimetableTypeAndIdToUserDefaults(type: nil, id: nil)
        navigationController?.popViewController(animated: true)
    }

}


extension ContainerTimetableViewController: ControlTimetableDelegate {
    
    func popTimetableViewController() {
        popViewController()
    }
    
    func setWeekNumber(number: Int) {
        let tableName = "Timetable"
        
        rightBarButton.setTitle("\(number + 1) \("week".localized(using: tableName))", for: .normal)
    }
    
    func setControlIsUserInteractionEnabled(_ a: Bool) {
        rightBarButton.isUserInteractionEnabled = a
    }
    
}
