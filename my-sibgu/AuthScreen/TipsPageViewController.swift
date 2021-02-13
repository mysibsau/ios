//
//  TipsPageViewController.swift
//  my-sibgu
//
//  Created by art-off on 08.02.2021.
//

import UIKit

protocol TipsPageViewControllerDelegate {
    func showAuthScreen()
}

class TipsPageViewController: UIPageViewController {
    
    var authDelegate: TipsPageViewControllerDelegate?
    
    private var tipViewControllers: [UIViewController] = []
    
    
    private var currPageIndex = 0
    
    private var segmentedControl: SegmentedControl!
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        view.backgroundColor = UIColor.Pallete.content
        
        let tableName = "Trips"
        
        let vc0 = StartViewController()
        
        let vc1 = TipViewController(
            titleText: "feed".localized(using: tableName),
            whatIsItText: "feed.what".localized(using: tableName),
            howIsItText: "feed.how".localized(using: tableName),
            image: UIImage(named: "events_tab")!.withRenderingMode(.alwaysTemplate)
        )
        vc1.view.backgroundColor = .init(hex: "#006AB3")
        
        let vc2 = TipViewController(
            titleText: "menu".localized(using: tableName),
            whatIsItText: "menu.what".localized(using: tableName),
            howIsItText: "menu.how".localized(using: tableName),
            image: UIImage(named: "restaurant")!.withRenderingMode(.alwaysTemplate)
        )
        vc2.view.backgroundColor = .init(hex: "#7DC71C")
        
        let vc3 = TipViewController(
            titleText: "timetable".localized(using: tableName),
            whatIsItText: "timetable.what".localized(using: tableName),
            howIsItText: "timetable.how".localized(using: tableName),
            image: UIImage(named: "timetable_tab")!.withRenderingMode(.alwaysTemplate)
        )
        vc3.view.backgroundColor = .init(hex: "#EF8531")
        
        let vc4 = TipViewController(
            titleText: "services".localized(using: tableName),
            whatIsItText: "services.what".localized(using: tableName),
            howIsItText: "services.how".localized(using: tableName),
            image: UIImage(systemName: "square.grid.2x2")!.withRenderingMode(.alwaysTemplate)
        )
        vc4.view.backgroundColor = .init(hex: "#77787B'")
        
        let vc5 = TipViewController(
            titleText: "profile".localized(using: tableName),
            whatIsItText: "profile.what".localized(using: tableName),
            howIsItText: "profile.how".localized(using: tableName),
            image: UIImage(systemName: "person.fill")!.withRenderingMode(.alwaysTemplate)
        )
        vc5.view.backgroundColor = .init(hex: "#FF0000")
        
        tipViewControllers = [
            vc0,
            vc1,
            vc2,
            vc3,
            vc4,
            vc5
        ]
        self.setViewControllers([vc0], direction: .forward, animated: true, completion: nil)
        
        
        addButton()
    }
    
    private func addButton() {
        let button = UIButton()
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        button.backgroundColor = UIColor.Pallete.sibsuBlue
        button.layer.cornerRadius = 15
        button.makeShadow()
        button.makeBorder()
        
        button.setTitle("Окей", for: .normal)
        button.setTitleColor(UIColor.Pallete.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapButton() {
        if currPageIndex < tipViewControllers.count - 1 {
            horisontalScrollToViewController(index: currPageIndex + 1)
        } else {
            authDelegate?.showAuthScreen()
        }
    }
    
    private func horisontalScrollToViewController(index: Int, direction: UIPageViewController.NavigationDirection = .forward) {
        navigationController?.view.isUserInteractionEnabled = false
        setViewControllers(
            [tipViewControllers[index]],
            direction: direction,
            animated: true,
            completion: { finished in
                self.navigationController?.view.isUserInteractionEnabled = true
                self.currPageIndex = index
            }
        )
    }

}

extension TipsPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currIndex = tipViewControllers.firstIndex(of: viewController) else { return nil }
        guard currIndex > 0 else { return nil }
        
        return tipViewControllers[currIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currIndex = tipViewControllers.firstIndex(of: viewController) else { return nil }
        guard currIndex < tipViewControllers.count - 1 else { return nil }
        
        return tipViewControllers[currIndex + 1]
    }

}

extension TipsPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let firstViewController = viewControllers?.first,
            let index = tipViewControllers.firstIndex(of: firstViewController),
            completed
        else {
            return
        }
        
        currPageIndex = index
    }
    
}
