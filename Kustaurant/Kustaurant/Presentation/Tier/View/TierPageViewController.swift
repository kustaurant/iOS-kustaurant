//
//  TierPageViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

protocol TierPageViewControllerDelegate: AnyObject {
    func pageViewController(_ pageViewController: TierPageViewController, didSelectPageAt index: Int)
}

final class TierPageViewController: UIPageViewController {
    private var pages: [UIViewController] = [
        TierListViewController(),
        TierMapViewController()
    ]
    private var currentIndex: Int {
        guard let viewController = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: viewController) ?? 0
    }
    
    weak var pageDelegate: TierPageViewControllerDelegate?
    
    // MARK: - Initialization
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }
}

extension TierPageViewController {
    private func setViewControllersInPageVC() {
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setPage(index: Int) {
        guard index >= 0 && index < pages.count else { return }
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource
extension TierPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == pages.count {
            return nil
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension TierPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentVC = viewControllers?.first,
              let index = pages.firstIndex(of: currentVC)
        else { return }
        pageDelegate?.pageViewController(self, didSelectPageAt: index)
    }
}
