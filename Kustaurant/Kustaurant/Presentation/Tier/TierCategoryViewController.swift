//
//  TierCategoryViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/30/24.
//

import UIKit
import Combine

final class TierCategoryViewController: UIViewController {
    private var viewModel: TierCategoryViewModel
    private var tierCategoryCollectionViewHandler: TierCategoryCollectionViewHandler?
    private var tierCategoryView = TierCategoryView()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: TierCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tierCategoryCollectionViewHandler = TierCategoryCollectionViewHandler(
            view: tierCategoryView,
            viewModel: viewModel
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = tierCategoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
}

// MARK: - Actions
extension TierCategoryViewController {
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Bind
extension TierCategoryViewController {
    private func setupBinding() {
        bindCategories()
    }
    
    private func bindCategories() {
        viewModel.cuisinesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tierCategoryCollectionViewHandler?.reloadSection(indexSet: IndexSet(integer: 0))
            }
            .store(in: &cancellables)

        viewModel.situationsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tierCategoryCollectionViewHandler?.reloadSection(indexSet: IndexSet(integer: 1))
            }
            .store(in: &cancellables)

        viewModel.locationsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tierCategoryCollectionViewHandler?.reloadSection(indexSet: IndexSet(integer: 2))
            }
            .store(in: &cancellables)
    }
}

extension TierCategoryViewController {
    private func setupUI() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let icon = UIImage(named: "icon_back")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "카테고리"
    }
}
