//
//  InformingPageViewController.swift
//  my-sibgu
//
//  Created by art-off on 14.01.2021.
//

import UIKit

class InformingPageViewController: UIPageViewController {
    
    
    private var informingViewControllers: [UIViewController] = []
    
    
    private var currPageIndex = 0
    
    private var segmentedControl: MySegmentedControl!
    
    
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
        
        view.backgroundColor = .systemBackground
        
        setSegmentedController()
        
        let vc1 = EventsViewController()
        let vc2 = NewsViewController()
        let vc3 = UIViewController()
        let vc4 = UIViewController()
        
        informingViewControllers = [
            vc1,
            vc2,
//            vc3,
//            vc4,
        ]
        
        self.setViewControllers([vc1], direction: .forward, animated: true, completion: nil)
    }
    
    private func setSegmentedController() {
        for v in view.subviews {
            if v is UIScrollView {
                (v as! UIScrollView).delegate = self
            }
        }
        
        segmentedControl = MySegmentedControl(items: ["Новости", "События"], sectionWidth: 90)
        
        let tapToLeft = UITapGestureRecognizer(target: self, action: #selector(eventsTapped))
        let tapToRight = UITapGestureRecognizer(target: self, action: #selector(newsTapped))
        
        segmentedControl.sectionLabels[0].addGestureRecognizer(tapToLeft)
        segmentedControl.sectionLabels[1].addGestureRecognizer(tapToRight)
        
        navigationItem.titleView = segmentedControl
    }
    
    @objc
    private func eventsTapped() {
        if currPageIndex == 1 {
            horisontalScrollToViewController(index: 0, direction: .reverse)
            self.segmentedControl.setCurrentSection(number: 0)
        }
    }
    
    @objc
    private func newsTapped() {
        if currPageIndex == 0 {
            horisontalScrollToViewController(index: 1, direction: .forward)
            self.segmentedControl.setCurrentSection(number: 1)
        }
    }
    
    private func horisontalScrollToViewController(index: Int, direction: UIPageViewController.NavigationDirection = .forward) {
        navigationController?.view.isUserInteractionEnabled = false
        setViewControllers(
            [informingViewControllers[index]],
            direction: direction,
            animated: true,
            completion: { finished in
                self.navigationController?.view.isUserInteractionEnabled = true
                self.currPageIndex = index
            }
        )
    }

}

extension InformingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currIndex = informingViewControllers.firstIndex(of: viewController) else { return nil }
//        guard currIndex == 1 else { return nil }
        guard currIndex > 0 else { return nil }
        
        return informingViewControllers[currIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currIndex = informingViewControllers.firstIndex(of: viewController) else { return nil }
//        guard currIndex == 0 else { return nil }
        guard currIndex < 1 else { return nil }
        
        return informingViewControllers[currIndex + 1]
    }

}

extension InformingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let firstViewController = viewControllers?.first,
            let index = informingViewControllers.firstIndex(of: firstViewController),
            completed
        else {
            return
        }
        
        segmentedControl.setCurrentSection(number: index)
        
        currPageIndex = index
    }
    
}

extension InformingPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let bounds = scrollView.bounds.width
        let page = CGFloat(self.currPageIndex)
        let count = CGFloat(informingViewControllers.count)
        let percentage = (offset - bounds + page * bounds) / (count * bounds - bounds) * (count - 1)
        
        print(offset, percentage)
        
        segmentedControl.setLineOffset(percentageOffset: percentage)
    }
    
}
