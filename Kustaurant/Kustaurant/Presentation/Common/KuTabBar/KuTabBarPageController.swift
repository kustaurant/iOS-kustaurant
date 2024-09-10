//
//  KuTabBarPageController.swift
//  Kustaurant
//
//  Created by 류연수 on 8/1/24.
//

import UIKit
import Combine

extension KuTabBarPageController {
    
    struct Tab {
        let title: String
        let viewController: UIViewController
    }
}

final class KuTabBarPageController: UIView {
    
    private let tabBarView: KuTabBarView
    private let pageViewController: UIPageViewController = .init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let viewControllers: [UIViewController]
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private(set) var currentPageIndex: Int = 0
    
    init(tabs: [Tab], style: KuTabBarView.Style) {
        self.tabBarView = .init(tabs: tabs.map { $0.title }, style: style)
        self.viewControllers = tabs.map { $0.viewController }
        
        super.init(frame: .zero)
        
        setupStyle()
        setupLayout()
        setupParentViewController()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KuTabBarPageController {
    
    private func setupStyle() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    private func setupLayout() {
        addSubview(tabBarView, autoLayout: [.top(0), .fillX(0), .height(60.33)])
        addSubview(pageViewController.view, autoLayout: [.topNext(to: tabBarView, constant: 0), .fillX(0), .bottom(0)])
    }
    
    private func setupParentViewController() {
        guard let parentViewController else { return }
        
        parentViewController.addChild(pageViewController)
        pageViewController.didMove(toParent: parentViewController)
        
        if let firstViewController = viewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    private func bind() {
        tabBarView.actionPublisher
            .sink { [weak self] action in
                switch action {
                case .didSelect(let index):
                    self?.updatePageViewController(as: index)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updatePageViewController(as index: Int) {
        guard let viewController = viewControllers[safe: index]
        else { return }
        
        let direction: UIPageViewController.NavigationDirection = currentPageIndex < index ? .forward : .reverse
        currentPageIndex = index
        pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
}

extension KuTabBarPageController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = viewControllers.firstIndex(of: currentViewController),
              (0..<viewControllers.count) ~= currentIndex
        else { return }
        
        currentPageIndex = currentIndex
        tabBarView.state = .tabDidChange(to: currentIndex)
        updatePageViewController(as: currentIndex)
    }
}

extension KuTabBarPageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return viewControllers[safe: index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else {
            return nil
        }
        return viewControllers[safe: index + 1]
    }
}
