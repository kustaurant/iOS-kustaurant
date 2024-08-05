//
//  TierListViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit
import Combine

final class TierListViewController: UIViewController {
    private var viewModel: TierListViewModel
    private var tierListTableViewHandler: TierListTableViewHandler?
    private var tierListCategoriesCollectionViewHandler: TierListCategoriesCollectionViewHandler?
    private var tierListView = TierListView()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: TierListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tierListTableViewHandler = TierListTableViewHandler(
            view: tierListView,
            viewModel: viewModel
        )
        tierListCategoriesCollectionViewHandler = TierListCategoriesCollectionViewHandler(
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchTierLists()
        setupBindings()
    }
}

extension TierListViewController {
    func receiveTierCategories(categories: [Category]) {
        viewModel.updateCategories(categories: categories)
        tierListCategoriesCollectionViewHandler?.reloadData()
    }
}

extension TierListViewController {
    private func setupBindings() {
        bindtierRestaurants()
        bindCategoryButton()
    }
    
    private func bindtierRestaurants() {
        viewModel.tierRestaurantsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tierListTableViewHandler?.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindCategoryButton() {
        tierListView.categoryButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.categoryButtonTapped()
        }, for: .touchUpInside)
    }
}
