//
//  TierPageViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

final class TierViewController: UIPageViewController {
    private var tierNaviationTitleTabView = TierNavigationTitleTabView()
    var pages: [UIViewController]
    private var navigationBarBottomBorder: UIView?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBottomBorderToNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBarBottomBorder?.removeFromSuperview()
    }
}

// MARK: - Actions
extension TierViewController {
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension TierViewController {
    private func setupNavigationBar() {
        navigationItem.titleView = tierNaviationTitleTabView
        configureBackButtonIfNeeded()
    }
    
    private func configureBackButtonIfNeeded() {
        // 네비게이션 스택에 현재 뷰컨트롤러가 루트가 아닌 경우에만 백 버튼을 추가
        if navigationController?.viewControllers.count ?? 0 > 1 {
            let icon = UIImage(named: "icon_back")?.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    private func addBottomBorderToNavigationBar() {
        let borderView = UIView()
        borderView.backgroundColor = .gray100
        navigationController?.navigationBar.addSubview(borderView, autoLayout: [.fillX(0), .bottom(0), .height(1.5)])
        navigationBarBottomBorder = borderView
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
