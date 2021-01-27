//
//  TimetableViewController.swift
//  my-sibgu
//
//  Created by art-off on 23.11.2020.
//

import UIKit

class TimetableViewController: UIPageViewController {

    private let timetableSercive = TimetableService()
    private let dateTimeService = DateTimeService()
    
    private weak var alertingDelegate: AlertingViewController?
    private weak var controlTimetableDelegate: ControlTimetableDelegate?

    private var group: Group!

    var rightBarButton: UIButton?

    private var weekViewControllers = [WeekViewController]()
    private var displayedWeek = 0

    // MARK: - Private UI
    private let activityIndicatorView = UIActivityIndicatorView()


    // MARK: - Initialization
    convenience init(group: Group, controlDelegate: ControlTimetableDelegate, alertingDelegate: AlertingViewController? = nil) {
        self.init()
        self.group = group
        self.controlTimetableDelegate = controlDelegate
        self.alertingDelegate = alertingDelegate
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ovverides
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Pallete.background
        
        self.dataSource = self
        self.delegate = self
        
        loadTimetable(withId: group.id)
    }
    
    
    // MARK: - Private Methods
    private func loadTimetable(withId id: Int) {
        self.startActivityIndicator()
        self.controlTimetableDelegate?.setControlIsUserInteractionEnabled(false)
//        timetableSercive.loadTimetable(
//            withId: id,
//            completionIfNeedNotLoadGroups: { groupTimetable in
//                guard let gt = groupTimetable else {
//                    DispatchQueue.main.async {
//                        print("hello")
//                        self.actionIfNotDownloaded()
//                    }
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    self.set(timetable: gt)
//                    self.stopActivityIndicator()
//                    self.controlTimetableDelegate?.setControlIsUserInteractionEnabled(true)
//                }
//            },
//            startIfNeedLoadGroups: {
//                // Тут лучше бы говорить, что скачиваются группы
//                print("Hello")
//            },
//            completionIfNeedLoadGroups: { groupTimetable in
//                guard let gt = groupTimetable else {
//                    DispatchQueue.main.async {
//                        self.actionIfNotDownloaded()
//                    }
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    self.set(timetable: gt)
//                    self.stopActivityIndicator()
//                    self.controlTimetableDelegate?.setControlIsUserInteractionEnabled(true)
//                }
//            }
//        )
    }
    
    private func actionIfNotDownloaded() {
        stopActivityIndicator()
        rightBarButton?.isUserInteractionEnabled = true
        controlTimetableDelegate?.popTimetableViewController()
        alertingDelegate?.showNetworkAlert()
    }
    
    private func set(timetable: GroupTimetable) {
        let currWeekNumber = dateTimeService.currWeekNumber()
        let currWeekdayNumber = dateTimeService.currWeekdayNumber() - 1
        
        weekViewControllers = [
            WeekViewController(week: timetable.weeks[0], weekNumber: 0, todayNumber: (currWeekNumber == 0 ? currWeekdayNumber : nil)),
            WeekViewController(week: timetable.weeks[1], weekNumber: 1, todayNumber: (currWeekNumber == 1 ? currWeekdayNumber : nil))
        ]
        
        horisontalScrollToViewController(viewController: weekViewControllers[currWeekNumber])
        setWeekNumber(number: currWeekNumber)
    }
    
    private func horisontalScrollToViewController(viewController: UIViewController, direction: UIPageViewController.NavigationDirection = .forward) {
        navigationController?.view.isUserInteractionEnabled = false
        setViewControllers(
            [viewController],
            direction: direction,
            animated: true,
            completion: { finished in
                self.navigationController?.view.isUserInteractionEnabled = true
            })
    }
    
    private func toggleWeekNumber() {
        if displayedWeek == 0 {
            setWeekNumber(number: 1)
        } else if displayedWeek == 1 {
            setWeekNumber(number: 0)
        }
    }
    
    private func setWeekNumber(number: Int) {
        controlTimetableDelegate?.setWeekNumber(number: number)
        displayedWeek = number
    }

}

extension TimetableViewController: AnimatingNetworkProtocol {

    func animatingActivityIndicatorView() -> UIActivityIndicatorView {
        return activityIndicatorView
    }

    func animatingSuperViewForDisplay() -> UIView {
        return view
    }

}

extension TimetableViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currVC = viewController as? WeekViewController else { return nil }
        let currIndex = currVC.weekNumber!

        if currIndex == 0 { return nil }

        let vc = weekViewControllers[currIndex - 1]
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currVC = viewController as? WeekViewController else { return nil }
        let currIndex = currVC.weekNumber!

        if currIndex == 1 { return nil }

        let vc = weekViewControllers[currIndex + 1]
        return vc
    }

}

extension TimetableViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        if completed && previousViewControllers.first! == weekViewControllers[displayedWeek] {
            toggleWeekNumber()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // выключаем кнопки на нав бар, когда начинается скролл (чтобы не нажали на кнопку смены экранов)
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
}

extension TimetableViewController: ShowingTimetableViewController {
    
    func scrollToOtherWeek() {
        if displayedWeek == 0 {
            horisontalScrollToViewController(viewController: weekViewControllers[1], direction: .forward)
            toggleWeekNumber()
        } else if displayedWeek == 1 {
            horisontalScrollToViewController(viewController: weekViewControllers[0], direction: .reverse)
            toggleWeekNumber()
        }
    }
    
}
