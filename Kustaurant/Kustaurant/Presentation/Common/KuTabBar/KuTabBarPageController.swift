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
    }
    
    private func bind() {
        tabBarView.actionPublisher
            .sink { [weak self] action in
                switch action {
                case .didSelect(let index):
                    guard let viewController = self?.viewControllers[safe: index],
                          let currentPageIndex = self?.currentPageIndex
                    else { return }
                    let direction: UIPageViewController.NavigationDirection = currentPageIndex < index ? .forward : .reverse
                    self?.currentPageIndex = index
                    self?.pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
                }
            }
            .store(in: &cancellables)
    }
    
    private func pageDidChange(at index: Int) -> UIViewController? {
        tabBarView.state = .tabDidChange(to: index)
        currentPageIndex = index
        return viewControllers[safe: index]
    }
}

extension KuTabBarPageController: UIPageViewControllerDelegate {
    
}

extension KuTabBarPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pageDidChange(at: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else {
            return nil
        }
        return pageDidChange(at: index + 1)
    }
    
}
