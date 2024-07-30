//
//  TierPageViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

final class TierViewController: UIPageViewController {
    private var tierNaviationTitleTabView = TierNavigationTitleTabView()
    private var pages: [UIViewController]
    private var currentIndex: Int {
        guard let viewController = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: viewController) ?? 0
    }

    // MARK: - Initialization
    init(
        tierListViewController: TierListViewController,
        TierMapViewController: TierMapViewController
    ) {
        pages = [tierListViewController, TierMapViewController]
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        delegate = self
        dataSource = self
        tierNaviationTitleTabView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setViewControllersInPageVC()
    }
}

extension TierViewController {
    private func setupNavigationBar() {
        navigationItem.titleView = tierNaviationTitleTabView
    }
    
    private func setViewControllersInPageVC() {
        setPage(index: 0)
        tierNaviationTitleTabView.updateTabSelection(selectedIndex: 0)
    }
    
    private func setPage(index: Int) {
        guard index >= 0 && index < pages.count else { return }
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource
extension TierViewController: UIPageViewControllerDataSource {
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
extension TierViewController: UIPageViewControllerDelegate {
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
        tierNaviationTitleTabView.updateTabSelection(selectedIndex: index)
    }
}

// MARK: - TierNavigationTitleTabViewDelegate
extension TierViewController: TierNavigationTitleTabViewDelegate {
    func tabView(
        _ tabView: TierNavigationTitleTabView,
        didSelectTabAt index: Int
    ) {
        setPage(index: index)
    }
}
