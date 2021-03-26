//
//  LibraryPageViewController.swift
//  my-sibgu
//
//  Created by art-off on 25.02.2021.
//

import UIKit

class LibraryPageViewController: UIPageViewController {
    
    var digitalBooks: [DigitalBook]!
    var physicalBooks: [PhysicalBook]!
    
    private var informingViewControllers: [UIViewController] = []
    
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
        
        view.backgroundColor = UIColor.Pallete.background
        
        setSegmentedController()
        
        let vc1 = BooksTableViewController()
        let vc2 = BooksTableViewController()
        vc1.viewModel = .digital(digitalBooks)
        vc2.viewModel = .physical(physicalBooks)
        
        informingViewControllers = [
            vc2,
            vc1,
        ]
        
        self.setViewControllers([vc2], direction: .forward, animated: true, completion: nil)
        
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: .languageChanged, object: nil)
    }
    
    @objc
    private func updateText() {
        let tableName = "Library"
        
        segmentedControl.sectionLabels[0].text = "physical".localized(using: tableName)
        segmentedControl.sectionLabels[1].text = "digital".localized(using: tableName)
    }
    
    private func setSegmentedController() {
        for v in view.subviews {
            if v is UIScrollView {
                (v as! UIScrollView).delegate = self
            }
        }
        
        segmentedControl = SegmentedControl(items: ["physical", "digital"], sectionWidth: 100)
        segmentedControl.delegate = self
        
        navigationItem.titleView = segmentedControl
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

extension LibraryPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currIndex = informingViewControllers.firstIndex(of: viewController) else { return nil }
        guard currIndex > 0 else { return nil }
        
        return informingViewControllers[currIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currIndex = informingViewControllers.firstIndex(of: viewController) else { return nil }
        guard currIndex < informingViewControllers.count - 1 else { return nil }
        
        return informingViewControllers[currIndex + 1]
    }

}

extension LibraryPageViewController: UIPageViewControllerDelegate {
    
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

extension LibraryPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let bounds = scrollView.bounds.width
        let page = CGFloat(self.currPageIndex)
        let count = CGFloat(informingViewControllers.count)
        let percentage = (offset - bounds + page * bounds) / (count * bounds - bounds) * (count - 1)
        
        segmentedControl.setLineOffset(percentageOffset: percentage)
    }
    
}

extension LibraryPageViewController: SegmentedControlDelegate {
    
    func didTapToSegment(with index: Int) {
        if currPageIndex < index {
            horisontalScrollToViewController(index: index, direction: .forward)
            self.segmentedControl.setCurrentSection(number: index)
        } else if currPageIndex > index {
            horisontalScrollToViewController(index: index, direction: .reverse)
            self.segmentedControl.setCurrentSection(number: index)
        }
    }
    
}
