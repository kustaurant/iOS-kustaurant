//
//  SavedRestaurantsViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import UIKit
import Combine

class SavedRestaurantsViewController: NavigationBarLeftBackButtonViewController, NavigationBarHideable {
    
    private let viewModel: SavedRestaurantsViewModel
    private var cancellables = Set<AnyCancellable>()
    private let savedRestaurantsView = SavedRestaurantsView()
    private var savedRestaurantsTableViewHandler: SavedRestaurantsTableViewHandler?
    
    init(viewModel: SavedRestaurantsViewModel) {
        self.viewModel = viewModel
        self.savedRestaurantsTableViewHandler = SavedRestaurantsTableViewHandler(view: savedRestaurantsView, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getFavoriteRestaurants()
        bind()
    }
    
    override func loadView() {
        view = savedRestaurantsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(animated: false)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "저장된 맛집"
    }
}

extension SavedRestaurantsViewController {
    
    private func bind() {
        viewModel.favoriteRestaurantsPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] restaurants in
                if restaurants.isEmpty {
                    self?.savedRestaurantsView.emptyView.isHidden = false
                } else {
                    self?.savedRestaurantsView.emptyView.isHidden = true
                    self?.savedRestaurantsTableViewHandler?.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}
