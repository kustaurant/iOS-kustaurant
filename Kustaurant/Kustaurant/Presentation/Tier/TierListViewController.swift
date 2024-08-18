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
    private var categoriesCollectionViewHandler: TierTopCategoriesCollectionViewHandler?
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
        categoriesCollectionViewHandler = TierTopCategoriesCollectionViewHandler(
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
        setupBindings()
    }
}

extension TierListViewController {
    func receiveTierCategories(categories: [Category]) {
        viewModel.updateCategories(categories: categories)
    }
}

extension TierListViewController {
    private func setupBindings() {
        bindtierRestaurants()
        bindCategories()
        bindCategoryButton()
    }
    
    private func bindCategories() {
        viewModel.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.categoriesCollectionViewHandler?.reloadData()
                self?.viewModel.fetchTierLists()
            }.store(in: &cancellables)
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
        tierListView.topCategoriesView.categoryButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.categoryButtonTapped()
        }, for: .touchUpInside)
    }
}
