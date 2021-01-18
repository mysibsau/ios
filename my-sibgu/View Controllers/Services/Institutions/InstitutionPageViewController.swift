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
        
        view.backgroundColor = .systemBackground
        
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = Colors.sibsuBlue
        
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.navigationItem.setCenterTitle(title: institute.shortName)
        
        let vc1 = PersonViewController(director: institute.director!)
        let vc2 = DepartmentsViewController()
        vc2.departments = institute.departments
        let vc3 = PersonViewController(soviet: institute.soviet!)
        
        institutionsViewControllers = [
            vc1,
            vc2,
            vc3
        ]
        
        self.setViewControllers([vc1], direction: .forward, animated: true, completion: nil)
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
            let index = institutionsViewControllers.firstIndex(of: firstViewController),
            completed
        else {
            return
        }
        pageControl.currentPage = index
    }
    
}
