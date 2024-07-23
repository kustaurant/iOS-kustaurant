//
//  TierListViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

final class TierListViewController: UIViewController {
    private var viewModel: TierListViewModel
    private var tierListTableViewHandler: TierListTableViewHandler?
    private var tierListView = TierListView()
    
    // MARK: - Initialization
    init(viewModel: TierListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tierListTableViewHandler = TierListTableViewHandler(
            view: tierListView,
            viewModel: viewModel
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = tierListView
    }
}
