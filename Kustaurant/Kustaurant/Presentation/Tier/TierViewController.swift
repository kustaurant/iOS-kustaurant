//
//  TierViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class TierViewController: UIViewController {
    private var viewModel: TierViewModel
    private var tierView = TierView()
    private var tierNaviationTitleTabView = TierNavigationTitleTabView()
    
    // MARK: - Initialization
    init(viewModel: TierViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = tierView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        tierNaviationTitleTabView.delegate = self
        tierView.pageViewController.pageDelegate = self
        
        tierView.pageViewController.setPage(index: 0)
        tierNaviationTitleTabView.updateTabSelection(selectedIndex: 0)
    }
}

extension TierViewController {
    private func setupNavigationBar() {
        let backImage = UIImage(systemName: "arrow.backward")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = tierNaviationTitleTabView
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - TierNavigationTitleTabViewDelegate
extension TierViewController: TierNavigationTitleTabViewDelegate {
    func tabView(
        _ tabView: TierNavigationTitleTabView,
        didSelectTabAt index: Int
    ) {
        tierView.pageViewController.setPage(index: index)
    }
}

// MARK: - TierPageViewControllerDelegate
extension TierViewController: TierPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: TierPageViewController,
        didSelectPageAt index: Int
    ) {
        tierNaviationTitleTabView.updateTabSelection(selectedIndex: index)
    }
}
