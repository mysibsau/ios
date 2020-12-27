//
//  InstitutionPageViewController.swift
//  my-sibgu
//
//  Created by art-off on 27.12.2020.
//

import UIKit
import SnapKit

class InstitutionPageViewController: UIPageViewController {
    
    var institute: Institute!
    
    private let pageControl = UIPageControl()
    private var institutionsViewControllers: [UIViewController] = []
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        view.backgroundColor = .red
        
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = Colors.sibsuBlue
        
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .yellow
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .green
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        
        institutionsViewControllers = [
            vc2,
            PersonViewController(director: institute.director),
            PersonViewController(soviet: institute.soviet)
        ]
        
        self.setViewControllers([vc2], direction: .forward, animated: true, completion: nil)
    }
    
}

extension InstitutionPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currIndex = institutionsViewControllers.firstIndex(of: viewController) else { return nil }
        guard currIndex >= 1 && currIndex <= 2 else { return nil }
        
        return institutionsViewControllers[currIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currIndex = institutionsViewControllers.firstIndex(of: viewController) else { return nil }
        guard currIndex >= 0 && currIndex <= 1 else { return nil }
        
        return institutionsViewControllers[currIndex + 1]
    }

}

extension InstitutionPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let firstViewController = viewControllers?.first,
            let index = institutionsViewControllers.firstIndex(of: firstViewController)
        else {
            return
        }
        pageControl.currentPage = index
    }
    
}
